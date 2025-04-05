import numpy as np
from numba import njit
import os
import cv2
from skimage.util import pad
import math
from tqdm import tqdm
import numba as nb
from itertools import zip_longest
from sklearn.svm import LinearSVC

@njit
def bilinear_interpolation(x, y, top_left, top_right, bottom_left, bottom_right):
    dx = x - math.floor(x)
    dy = y - math.floor(y)

    top = (1 - dy) * top_left + dy * top_right
    bottom = (1 - dy) * bottom_left + dy * bottom_right
    return (1 - dx) * top + dx * bottom

@njit
def get_radial_means(image, x_pos, y_pos, patch_offset, means):
    for i in range(len(x_pos)):
        if np.floor(x_pos[i]) == x_pos[i] and np.floor(y_pos[i]) == y_pos[i]:
            x, y = int(x_pos[i]), int(y_pos[i])
            if patch_offset == 0:
                means[i] = image[x, y]
            else:
                neighbour_patch = image[x - patch_offset:x + patch_offset + 1, y - patch_offset:y + patch_offset + 1]
                means[i] = np.mean(neighbour_patch)
        else:
            minx, miny = math.floor(x_pos[i]), math.floor(y_pos[i])
            dx, dy = x_pos[i] - minx, y_pos[i] - miny

            x_poss = np.arange(minx - patch_offset, minx + patch_offset + 1, step=1, dtype=np.float32) + dx
            y_poss = np.arange(miny - patch_offset, miny + patch_offset + 1, step=1, dtype=np.float32) + dy
            interpolated_vals = np.zeros_like(x_poss)

            for j in range(len(x_poss)):
                x_floor = int(np.floor(x_poss[j]))
                y_floor = int(np.floor(y_poss[j]))
                x_ceil = int(np.ceil(x_poss[j]))
                y_ceil = int(np.ceil(y_poss[j]))
                top_left = image[x_floor, y_floor]
                top_right = image[x_ceil, y_floor]
                bottom_left = image[x_floor, y_ceil]
                bottom_right = image[x_ceil, y_ceil]
                interpolated_vals[j] = bilinear_interpolation(x_pos[i], y_pos[i], top_left, top_right, bottom_left, bottom_right)

            means[i] = np.mean(interpolated_vals)
            
class Image:
    def __init__(self, data, name, label):
        """
        Image and its metadata
        :param data: ndarray of original image data
        :param name: Name of image (eg: blanket1-a-p001)
        :param label: Category/label of image (eg: blanket1)
        """
        self.data = data
        self.name = name
        self.label = label
        self.featurevector = None  # Store featurevector calculated on normal image
        self.test_data = None  # Store test image with applied alterations (eg: Scale, noise)
        self.test_featurevector = None  # Store featurevector calculated on test image
        self.test_noise = None
        self.test_noise_val = None
        self.test_rotations = None
        self.test_scale = None

class MedianRobustExtendedLBP:
    def get_riu2_mappings(self,p: int):
        """
        Generate a mapping table from an LBP value to a riu2 bin.

        To summarise, riu2 classifies uniform LBPs (defined as U<=2, where U is the number of bitwise transitions) into p+1
        groups, and then puts non-uniform patterns into one group.
        """
        # Number of distinct LBP patterns to create mappings for
        size = 2 ** p

        # Create riu2 mappings table of unsigned integers
        mappings = [0] * size

        for i in range(0, size):
            # Convert i to representation as binary string
            binary = format(i, '08b')
            # Bit shift left by taking first digit and concatenating to end
            binary_lshift = binary[1:] + binary[:1]

            # Effectively, take each digit of 'binary' and 'binary_lshift' and check if there is a value difference.
            # When this is the case, it indicates a bitwise transition from 0 to 1 or 1 to 0.
            U, sum_bits = 0, 0
            for j in range(0, p):
                bit = binary[j]
                bit_lshift = binary_lshift[j]

                if bit != bit_lshift:
                    # bitwise transition
                    U += 1
                sum_bits += int(bit)  # Keep sum of bits

            if U <= 2:
                # Put uniform patterns into one of p+1 groups
                # Eg: If p=4 we have a group for every sum of bits. 0000 = 0, 0001 = 1, 0011 = 2, 0111 = 3, 1111 = 4
                # Forming 5 separate groups
                mappings[i] = sum_bits
            else:
                # Put non-uniform patterns into one group
                mappings[i] = p + 1  # p + 1 case
        return mappings
    
    def __init__(self, r1=None, p=8, w_center=3, w_r1=None, save_img=False):
        """
        :param r1: int or [int]. Radius(s) to use in RELBP_NI and RELBP_RD descriptors
        :param p: int. Number of neighbours for LBP
        :param w_center: int. Patch size for median filter and calculating RELBP_CI. Must be odd.
        :param w_r1: int or [int]. Patch size to use for each value of r1. Length must match r1's. Must be odd.
        """
        # Assign default values if not provided
        self.r1 = [2, 4, 6, 8] if r1 is None else ([r1] if isinstance(r1, int) else r1)
        self.w_r1 = [3, 5, 7, 9] if w_r1 is None else ([w_r1] if isinstance(w_r1, int) else w_r1)
        self.p = p
        self.w_c = w_center
        self.save_img = save_img

        # Validate input parameters
        if self.p > 32:
            raise ValueError('Neighbours p cannot exceed 32')
        if self.w_c % 2 == 0:
            raise ValueError('Kernel size w_center must be an odd number')
        if any(w % 2 == 0 for w in self.w_r1):
            raise ValueError('All kernel sizes in w_r1 must be odd numbers')

        # Derived attributes
        self.map_dtype = np.uint8 if self.p <= 8 else np.uint16 if self.p <= 16 else np.uint32
        self.r_wr_scales = list(zip_longest(self.r1, self.w_r1, fillvalue=self.w_r1[0]))
        self.riu2_mapping = self.get_riu2_mappings(self.p)
        self.padding = max(self.r1) + int((max(self.w_r1) - 1) / 2)
        self.weights = np.fromiter((2 ** i for i in range(self.p)), dtype=self.map_dtype)
        self.radial_angles = (np.arange(0, self.p) * -(2 * math.pi) / self.p).astype(np.float32)
        
    # def median_filter(image, kernel_size, padding, out_filtered):
    #     """
    #     Perform median filter on image and write to out_filtered
    #     :param image: Image to perform median filter on
    #     :param kernel_size: Kernel to use in median filter, usually 3
    #     :param padding: Padding size used on image. Note: Must be greater than (kernel_size - 1) / 2.
    #     :param out_filtered: Pass an initialised array with same dimensions as image. This becomes the median image.
    #     :return: No return, since we're using numba guvectorize, instead an initialised empty image must be passed into
    #         out_filtered and this value is updated by the function.
    #     """
    #     width, height = image.shape
    #     patch = int((kernel_size - 1) / 2)
    #     for x in range(padding, width - padding):
    #         for y in range(padding, height - padding):
    #             out_filtered[x, y] = np.median(image[x - patch:x + patch + 1, y - patch:y + patch + 1])
    def median_filter(self, image, kernel_size, padding, out_filtered):
        """
        Perform median filter on image and write to out_filtered
        """
        width, height = image.shape
        patch = int((kernel_size - 1) / 2)
        for x in range(padding, width - padding):
            for y in range(padding, height - padding):
                out_filtered[x, y] = np.median(image[x - patch:x + patch + 1, y - patch:y + patch + 1])
                
    def write_image(self, image, folder, image_name):
        if folder is None:
            out_dir = os.path.join(os.getcwd(), 'example')
        else:
            out_dir = os.path.join(os.getcwd(), 'example', folder)

        # If requested folder doesn't exist, make it
        try:
            os.makedirs(out_dir)
        except FileExistsError:
            pass

        out_file = os.path.join(out_dir, image_name)
    
        print("out_file: ", out_file)

        cv2.imwrite(out_file, image)
    
    def convert_float32_image_uint8(self, image: np.ndarray):
        """
        Converts a float32 greyscale image_scaled normalised to zero mean and unit variance (in range [-1, 1]) 
        to a [0, 255] range (useful for writing images with cv2.imwrite).
        """
        norm_image = cv2.normalize(image, None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_8U)
        return norm_image
    
    def relbp_ci(self, image, w_c, padding):
        """

        :param image: float32 ndarray, scaled, padded image_scaled of zero mean and unit variance
                    For MRELBP_CI descriptor, also apply median filter beforehand
        :param w_c: CI kernel size
        :param padding: padding of image_scaled
        :return: RELBP_CI histogram
        """
        width, height = image.shape
        x_centre, y_centre = math.ceil(width / 2), math.ceil(height / 2)
        patch = int((w_c - 1) / 2)

        # Get the image_scaled excluding the zero-padding
        image_no_pad = image[padding:height - padding - 1, padding:width - padding - 1]
        # Get the central w_c*w_c section
        centre = image[x_centre - patch:x_centre + patch + 1, y_centre - patch:y_centre + patch + 1]

        # Calculate Centre Histogram
        diffs = centre - np.mean(image_no_pad)
        centre_hist = np.array([np.sum(diffs >= 0), np.sum(diffs < 0)], dtype=np.int32)

        return centre_hist

    # @njit
    # def bilinear_interpolation(x, y, top_left, top_right, bottom_left, bottom_right):
    #     dx = x - math.floor(x)
    #     dy = y - math.floor(y)

    #     top = (1 - dy) * top_left + dy * top_right
    #     bottom = (1 - dy) * bottom_left + dy * bottom_right
    #     return (1 - dx) * top + dx * bottom
    
    # @njit
    # def get_radial_means( image, x_pos, y_pos, patch_offset, means):
    #     """
    #     Gets the mean of a w*w size patch centred on x_pos and y_pos
    #     """
    #     # Calculate radial means for each position in r
    #     for i in range(len(x_pos)):
    #         # No interpolation required
    #         if np.floor(x_pos[i]) == x_pos[i] and np.floor(y_pos[i]) == y_pos[i]:
    #             x, y = int(x_pos[i]), int(y_pos[i])
    #             if patch_offset == 0:
    #                 # If no patch_offset, no mean is required.
    #                 means[i] = image[x, y]
    #             else:
    #                 neighbour_patch = image[x - patch_offset:x + patch_offset + 1, y - patch_offset:y + patch_offset + 1]
    #                 means[i] = np.mean(neighbour_patch)
    #         else:
    #             # Interpolation required
    #             minx, miny = math.floor(x_pos[i]), math.floor(y_pos[i])
    #             dx, dy = x_pos[i] - minx, y_pos[i] - miny

    #             # Find mean of w_r1*1_r1 patch centred on non-integer point
    #             x_poss = np.arange(minx - patch_offset, minx + patch_offset + 1, step=1, dtype=np.float32) + dx
    #             y_poss = np.arange(miny - patch_offset, miny + patch_offset + 1, step=1, dtype=np.float32) + dy
    #             interpolated_vals = np.zeros_like(x_poss)

    #             for j in range(len(x_poss)):
    #                 x_floor = int(np.floor(x_poss[j]))
    #                 y_floor = int(np.floor(y_poss[j]))
    #                 x_ceil = int(np.ceil(x_poss[j]))
    #                 y_ceil = int(np.ceil(y_poss[j]))
    #                 top_left = image[x_floor, y_floor]
    #                 top_right = image[x_ceil, y_floor]
    #                 bottom_left = image[x_floor, y_ceil]
    #                 bottom_right = image[x_ceil, y_ceil]
    #                 interpolated_vals[j] = bilinear_interpolation(x_pos[i], y_pos[i], top_left, top_right, bottom_left,
    #                                                   bottom_right)

    #             means[i] = np.mean(interpolated_vals)
    
    def perform_ni_rd_thresholding(self, image, padding, r1, r2, r1_offset, r2_offset, radial_angles, weights, lbp_ni, lbp_rd):
        """
        Vectorized function to perform RELBP_NI and RELBP_RD thresholding
        :param image: Greyscale image_scaled
        :param padding: Padding used on image_scaled
        :param r1: Radius for larger neighbourhood
        :param r2: Radius for smaller neighbourhood
        :param r1_offset: Pixel offset to achieve r1 kernel size
        :param r2_offset: Pixel offset to achieve r2 kernel size
        :param radial_angles: Angles for each of the neighbouring points from the evaluated point
        :param weights: 2^n weights for calculating the LBP_RD and RELBP_NI values (not riu2 mapped)
        :param lbp_ni: LBP_NI values evaluated for each pixel
        :param lbp_rd: LBP_RD values evaluated for each pixel
        :return:
        """
        width, height = image.shape
        for x_c in np.arange(padding, width - padding, dtype=np.uint16):
            for y_c in np.arange(padding, height - padding, dtype=np.uint16):
                x1s = np.empty(len(radial_angles), dtype=np.float32)
                y1s = np.empty(len(radial_angles), dtype=np.float32)
                x2s = np.empty(len(radial_angles), dtype=np.float32)
                y2s = np.empty(len(radial_angles), dtype=np.float32)

                for i in range(len(radial_angles)):
                    x1s[i] = x_c + r1 * math.cos(radial_angles[i])
                    y1s[i] = y_c + r1 * math.sin(radial_angles[i])
                    x2s[i] = x_c + r2 * math.sin(radial_angles[i])
                    y2s[i] = y_c + r2 * math.sin(radial_angles[i])

                N_vals_r1 = np.zeros(len(radial_angles), dtype=np.float32)
                N_vals_r2 = np.zeros(len(radial_angles), dtype=np.float32)
                get_radial_means(image, x1s, y1s, r1_offset, N_vals_r1)
                get_radial_means(image, x2s, y2s, r2_offset, N_vals_r2)

                # Neighbourhood mean thresholding (NI descriptor)
                N_vals_r1 = N_vals_r1 - np.mean(N_vals_r1)
                N_thresholded_ni = N_vals_r1 >= 0
                lbp_ni[x_c-padding, y_c-padding] = np.sum(N_thresholded_ni * weights)

                # Radial Neighbourhood thresholding (RD descriptor)
                N_vals_r2 = N_vals_r1 - N_vals_r2
                N_thresholded_rd = N_vals_r2 >= 0
                lbp_rd[x_c-padding, y_c-padding] = np.sum(N_thresholded_rd * weights)

    def relbp_ni_rd(self, image: np.ndarray, r1, w_r1, r2=None, w_r2=None):
        """
        Calculate RELBP_NI and RELBP_RD descriptor
        RELBP_NI Uses mean neighbourhood pixel intensity to threshold the neighbourhood to generate the binary pattern
        RELBP_RD Uses the larger neighbourhood thresholded against the nearer neighbourhood's mean pixel intensities
        :param image: float32 ndarray, scaled, padded image_scaled of zero mean and unit variance.
                    For MRELBP_NI, RD descriptors, also apply median filter beforehand
        :param r1: Radius for larger neighbourhood
        :param w_r1: Kernel size for larger neighbourhood
        :param r2: Optional: Radius for smaller neighbourhood
        :param w_r2: Optional: Kernel size for smaller neighbourhood
        :return: RELBP_NI, RELBP_RD histogram descriptors
        """
        # Handle initialisation of optional arguments
        if r2 is None:
            # This is the initialisation defined in the paper's section (9)
            r2 = r1 - 1
        else:
            if r1 <= r2:
                raise ValueError('r2 argument should be smaller or equal to r1')

        if w_r2 is None:
            w_r2 = w_r1 - 2
        else:
            if w_r2 % 2 == 0:
                raise ValueError('w_r2 kernel size must be odd value, but is even')
            if w_r1 <= w_r2:
                raise ValueError('w_r2 argument should be smaller or equal to r1')
        r1_offset = int((w_r1 - 1) / 2)
        r2_offset = int((w_r2 - 1) / 2)

        # Amount to offset from the patch's centre pixel to capture the w*w sized patch
        width, height = image.shape

        # Empty ndarray to store mapped values LBP values for each pixel
        LBPNI_mapped = np.zeros((width - 2 * self.padding, height - 2 * self.padding), dtype=self.map_dtype)
        LBPRD_mapped = np.zeros((width - 2 * self.padding, height - 2 * self.padding), dtype=self.map_dtype)

        lbp_ni = np.zeros((width, height), dtype=np.uint32)
        lbp_rd = np.zeros((width, height), dtype=np.uint32)
        try:
            self.perform_ni_rd_thresholding(image, self.padding, r1, r2, r1_offset, r2_offset,
                                            self.radial_angles, self.weights, lbp_ni, lbp_rd)
        except RuntimeWarning as e:
            print(e)
            print("RuntimeWarning in perform_ni_rd happened with the following arguments:")
            print("image type:", type(image), image.dtype)
            print("padding:", self.padding)
            print("r1", r1)
            print("r2", r2)
            print("r1_offset", r1_offset)
            print("r2_offset", r2_offset)
            print("radial angles", self.radial_angles)
            print("weights", self.weights)
            print("lbp_ni", lbp_ni)
            print("lbp_rd", lbp_rd)


        # Trim extra rows and columns
        lbp_ni = lbp_ni[:width-2 * self.padding, :height-2 * self.padding]
        lbp_rd = lbp_rd[:width-2 * self.padding, :height-2 * self.padding]

        for x in range(width - 2 * self.padding):
            for y in range(height - 2 * self.padding):
                LBPNI_mapped[x][y] = self.riu2_mapping[lbp_ni[x][y]]
                LBPRD_mapped[x][y] = self.riu2_mapping[lbp_rd[x][y]]

        return LBPNI_mapped, LBPRD_mapped
    
    def calculate_relbp(self, image: Image):
        """
        Calculates the RELBP descriptor (joint histogram of RELBP_CI, RELBP_NI, RELBP_RD)
        If you apply the Median filter before this, it is the MRELBP descriptor.
        If you perform noise classification + variable filters beforehand, it is the BM3DELBP descriptor.
        :param image: Image object or float32 ndarray, scaled & padded image_scaled of zero mean and unit variance.
        :return: Combined RELBP descriptor histogram
        """
        # if isinstance(image, Image):
        #     image_data = image.data
        # else:
        #     image_data = image
        # Generate r1 and w_r1 parameter pairs depending on whether user passed list or int for each.
        relbp_ni_rd = np.array([], dtype=np.int32)
        for r, w_r in self.r_wr_scales:
            if w_r % 2 == 0:
                raise ValueError('Kernel size w_r1 must be an odd number, but an even number was provided')
            if isinstance(image, np.ndarray):
                relbp_ni, relbp_rd = self.relbp_ni_rd(image, r, w_r)
            else:
                relbp_ni, relbp_rd = self.relbp_ni_rd(image.data, r, w_r)

            if self.save_img:
                if isinstance(image, np.ndarray):
                    raise ValueError('save_img set but passed as ndarray instead of DatasetManager.Image')
                else:
                    self.write_image(self.convert_float32_image_uint8(relbp_ni), 'MRELBP', '{}-RELBPNI_r-{}_wr-{}.png'.format(image.name, r, w_r))
                    self.write_image(self.convert_float32_image_uint8(relbp_rd), 'MRELBP', '{}-RELBPRD_r-{}_wr-{}.png'.format(image.name, r, w_r))

            relbp_ni_hist = np.histogram(relbp_ni, bins=256, range=(0, 256))[0].astype(dtype=np.int32)
            relbp_rd_hist = np.histogram(relbp_rd, bins=256, range=(0, 256))[0].astype(dtype=np.int32)
            relbp_ni_rd = np.concatenate((relbp_ni_rd, relbp_ni_hist, relbp_rd_hist))

        if isinstance(image, np.ndarray):
            relbp_ci_hist = self.relbp_ci(image, self.w_c, self.padding)
        else: 
            relbp_ci_hist = self.relbp_ci(image.data, self.w_c, self.padding)

        combined_histogram = np.concatenate((relbp_ci_hist, relbp_ni_rd))
        return combined_histogram
                
    def describe(self, image: Image):
        """
        Perform MRELBP Description for an Image
        :param image: float32 ndarray image_scaled with zero mean and unit variance.
        :param test_image: Boolean to determine if we are evaluating the test image (not used here).
        :param image_name: Optional name of the image for saving intermediate results.
        :return: MRELBP descriptor histogram
        """
        if not isinstance(image, Image):
            raise ValueError('Input image must be an instance of the Image class')

        # Zero-pad the image with a border
        image_padded = np.pad(image.data, pad_width=self.padding, mode='constant', constant_values=0)
        # Allocate memory for the filtered image
        image_filtered = np.zeros(image_padded.shape, dtype=np.float32)

        # Apply median filter to the padded image using the provided median_filter function
        self.median_filter(image_padded, self.w_c, self.padding, image_filtered)

        # Save intermediate images if save_img is enabled
        if self.save_img:
            self.write_image(
                self.convert_float32_image_uint8(image_padded),
                'MRELBP',
                f'{image.name}-padded.png'
            )
            self.write_image(
                self.convert_float32_image_uint8(image_filtered),
                'MRELBP',
                f'{image.name}-median-filtered.png'
            )
            describe_image = Image(image_filtered, image.name, None)
        else :
            describe_image = Image(image_filtered, None, None)

        # Calculate and return the MRELBP descriptor
        return self.calculate_relbp(describe_image)

# def save_descriptor_to_file(descriptor, filename):
#     """
#     Save the descriptor to a text file.
#     :param descriptor: The descriptor to save.
#     :param filename: The name of the file to save the descriptor to.
#     """
#     np.savetxt(filename, descriptor, fmt='%d')
    
# # Test the __init__ method
# if __name__ == "__main__":
#      # Đường dẫn đến hình ảnh
#     image_path = "D:/Capstone/Texture regconition based FPGAs/mrelbp+svm/COMP3200-Texture-Classification/data/kylberg-rotated/ceiling1/ceiling1-a-p001-r000.png"

#     # Đọc hình ảnh và chuyển đổi sang float32
#     image_data = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
#     image_data = image_data.astype(np.float32)

#     # Tạo đối tượng DatasetManager.Image
#     image = Image(data=image_data, name="example_image", label="ceiling1")

#     # Khởi tạo đối tượng MedianRobustExtendedLBP
#     r1 = [2, 4, 6, 8]
#     p = 8
#     w_center = 3
#     w_r1 = [3, 5, 7, 9]
#     save_img = True

#     mre_lbp = MedianRobustExtendedLBP(r1=r1, p=p, w_center=w_center, w_r1=w_r1, save_img=save_img)

#     # Gọi hàm describe
#     try:
#         descriptor = mre_lbp.describe(image)
#         # save_descriptor_to_file(descriptor, "descriptor.txt")
#         # print("MRELBP Descriptor:", descriptor)
#     except Exception as e:
#         print("Error during describe:", e)

# def load_image_paths_and_labels(root_dir, max_images_per_label=100):
#     """
#     Load image paths and labels from the root directory, limiting the number of images per label.
#     :param root_dir: Root directory containing subdirectories of images.
#     :param max_images_per_label: Maximum number of images to load per label.
#     :return: Tuple of image paths and labels.
#     """
#     image_paths = []
#     labels = []

#     for label in os.listdir(root_dir):
#         label_dir = os.path.join(root_dir, label)
#         if os.path.isdir(label_dir):
#             # Lấy danh sách các tệp trong thư mục và giới hạn số lượng ảnh
#             image_names = os.listdir(label_dir)[:max_images_per_label]
#             for image_name in image_names:
#                 image_path = os.path.join(label_dir, image_name)
#                 image_paths.append(image_path)
#                 labels.append(label)

#     # In ra thông tin kiểm tra
#     print(f"Found {len(image_paths)} images in {len(set(labels))} labels.")
#     for label in set(labels):
#         print(f"Label '{label}': {labels.count(label)} images")

#     return image_paths, labels

def resize_image(image, target_size=(128, 128)):
    """
    Resize hình ảnh về kích thước cố định.
    :param image: Hình ảnh đầu vào (ndarray).
    :param target_size: Kích thước đích (mặc định là 128x128).
    :return: Hình ảnh đã resize.
    """
    return cv2.resize(image, target_size, interpolation=cv2.INTER_AREA)

def load_balanced_image_paths_and_labels(root_dir):
    """
    Load image paths and labels from the root directory, balancing the number of images across labels.
    :param root_dir: Root directory containing subdirectories of images.
    :return: Tuple of balanced image paths and labels.
    """
    image_paths = []
    labels = []

    # Tạo dictionary để lưu danh sách ảnh theo từng nhãn
    label_to_images = {}

    for label in os.listdir(root_dir):
        label_dir = os.path.join(root_dir, label)
        if os.path.isdir(label_dir):
            # Lấy danh sách các tệp trong thư mục
            image_names = os.listdir(label_dir)
            image_paths_for_label = [os.path.join(label_dir, image_name) for image_name in image_names]
            label_to_images[label] = image_paths_for_label

    # Tìm số lượng ảnh nhỏ nhất trong tất cả các nhãn
    min_images_per_label = min(len(images) for images in label_to_images.values())

    # Lấy số lượng ảnh bằng với nhãn có số lượng ít nhất
    for label, images in label_to_images.items():
        balanced_images = images[:min_images_per_label]
        image_paths.extend(balanced_images)
        labels.extend([label] * len(balanced_images))

    # In thông tin kiểm tra
    print(f"Balanced dataset: {len(image_paths)} images across {len(set(labels))} labels.")
    for label in set(labels):
        print(f"Label '{label}': {labels.count(label)} images")

    return image_paths, labels

from tqdm import tqdm

# def extract_features(image_paths, mre_lbp):
#     """
#     Extract MRELBP features from image paths.
#     :param image_paths: List of image paths.
#     :param mre_lbp: MRELBP object.
#     :return: List of extracted features.
#     """
#     features = []

#     print("Extracting features from images...")
#     for image_path in tqdm(image_paths, desc="Processing images", unit="image"):
#         image_data = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
#         image_data = image_data.astype(np.float32)
#         image = Image(data=image_data, name=os.path.basename(image_path), label=None)
#         descriptor = mre_lbp.describe(image)
#         features.append(descriptor)

#     return features

# def extract_features_batch(image_paths, mre_lbp, batch_size=32):
#     """
#     Extract MRELBP features in batches, với resize hình ảnh trước khi tính toán.
#     :param image_paths: List of image paths.
#     :param mre_lbp: MRELBP object.
#     :param batch_size: Number of images to process at once.
#     :return: List of extracted features.
#     """
#     features = []
    
#     print(f"Extracting features in batches of {batch_size}...")
#     for i in tqdm(range(0, len(image_paths), batch_size), desc="Processing batches"):
#         batch_paths = image_paths[i:i+batch_size]
#         batch_images = []
        
#         # Load và resize batch images
#         for path in batch_paths:
#             img = cv2.imread(path, cv2.IMREAD_GRAYSCALE).astype(np.float32)
#             img_resized = resize_image(img, target_size=(128, 128))  # Resize về 128x128
#             batch_images.append(Image(data=img_resized, name=os.path.basename(path), label=None))
        
#         # Process batch
#         batch_features = [mre_lbp.describe(img) for img in batch_images]
#         features.extend(batch_features)
    
#     return features

from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm
import threading

def process_image_with_progress(image_path, mre_lbp, progress_bar):
    """
    Xử lý một hình ảnh: đọc, resize và trích xuất đặc trưng, đồng thời cập nhật progress bar.
    :param image_path: Đường dẫn đến hình ảnh.
    :param mre_lbp: Đối tượng MedianRobustExtendedLBP để trích xuất đặc trưng.
    :param progress_bar: Progress bar để cập nhật tiến trình.
    :return: Vector đặc trưng của hình ảnh.
    """
    # Đọc và resize hình ảnh
    image_data = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE).astype(np.float32)
    image_resized = resize_image(image_data, target_size=(128, 128))  # Resize về 128x128

    # Tạo đối tượng Image
    image = Image(data=image_resized, name=os.path.basename(image_path), label=None)

    # Trích xuất đặc trưng bằng MRELBP
    descriptor = mre_lbp.describe(image)

    # Cập nhật progress bar
    with progress_bar.get_lock():  # Đảm bảo thread-safe khi cập nhật progress bar
        progress_bar.update(1)

    return descriptor

def extract_features_parallel_with_progress(image_paths, mre_lbp, max_workers=4):
    """
    Trích xuất đặc trưng từ danh sách hình ảnh bằng cách xử lý song song và hiển thị tiến trình.
    :param image_paths: Danh sách đường dẫn đến hình ảnh.
    :param mre_lbp: Đối tượng MedianRobustExtendedLBP để trích xuất đặc trưng.
    :param max_workers: Số luồng tối đa để xử lý song song.
    :return: Danh sách các vector đặc trưng.
    """
    print(f"Extracting features in parallel using {max_workers} workers...")

    # Tạo progress bar tổng
    total_images = len(image_paths)
    progress_bar = tqdm(total=total_images, desc="Overall Progress", unit="image")

    # Sử dụng ThreadPoolExecutor để xử lý song song
    features = []
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # Tạo danh sách các tác vụ
        futures = [
            executor.submit(process_image_with_progress, path, mre_lbp, progress_bar)
            for path in image_paths
        ]

        # Thu thập kết quả từ các tác vụ
        for future in as_completed(futures):
            features.append(future.result())

    # Đóng progress bar
    progress_bar.close()

    return features


def prepare_training_data(features, labels):
    """
    Prepare training data and labels from features and labels.
    :param features: List of extracted features.
    :param labels: List of labels corresponding to the features.
    :return: Tuple of training data and labels.
    """
    X_train = np.stack(features, axis=0)
    y_train = np.array(labels)
    return X_train, y_train

# def train_svm(X_train, y_train):
#     """
#     Train an SVM classifier with a linear kernel and progress display.
#     :param X_train: Training data.
#     :param y_train: Training labels.
#     :return: Trained SVM classifier.
#     """
#     print("Training SVM classifier...")
#     classifier = SVC(kernel='linear')  # Sử dụng kernel tuyến tính
#     with tqdm(total=1, desc="Training SVM", unit="step") as pbar:
#         classifier.fit(X_train, y_train)
#         pbar.update(1)
#     return classifier

def train_svm_optimized(X_train, y_train):
    classifier = LinearSVC()
    classifier.fit(X_train, y_train)
    return classifier

# def save_svm_weights_and_bias(classifier, filename="svm_weights_and_bias.txt"):
#     """
#     Save the weights and bias of the SVM classifier to a file.
#     :param classifier: Trained SVM classifier.
#     :param filename: Name of the file to save the weights and bias.
#     """
#     if hasattr(classifier, 'coef_') and hasattr(classifier, 'intercept_'):
#         weights = classifier.coef_
#         bias = classifier.intercept_
#         with open(filename, 'w') as f:
#             f.write("Weights:\n")
#             np.savetxt(f, weights, fmt="%.6f")
#             f.write("\nBias:\n")
#             np.savetxt(f, bias, fmt="%.6f")
#         print(f"Weights and bias saved to {filename}")
#     else:
#         print("The classifier does not have accessible weights and bias (non-linear kernel).")

def evaluate_model(classifier, X_test, y_test):
    """
    Evaluate the SVM classifier.
    :param classifier: Trained SVM classifier.
    :param X_test: Test data.
    :param y_test: Test labels.
    :return: Accuracy of the classifier.
    """
    y_pred = classifier.predict(X_test)
    accuracy = np.mean(y_pred == y_test)
    return accuracy

# if __name__ == "__main__":
#     # Đường dẫn đến thư mục chứa các thư mục con của hình ảnh
#     root_dir = "D:/Capstone/Texture regconition based FPGAs/mrelbp+svm/COMP3200-Texture-Classification/data/kylberg-rotated"

#     # Đọc các tệp hình ảnh và nhãn (giới hạn 100 ảnh mỗi nhãn)
#     image_paths, labels = load_image_paths_and_labels(root_dir, max_images_per_label=100)

#     # Khởi tạo đối tượng MedianRobustExtendedLBP
#     r1 = [2, 4, 6, 8]
#     p = 8
#     w_center = 3
#     w_r1 = [3, 5, 7, 9]
#     save_img = False

#     mre_lbp = MedianRobustExtendedLBP(r1=r1, p=p, w_center=w_center, w_r1=w_r1, save_img=save_img)

#     # Trích xuất các đặc trưng bằng MRELBP
#     features = extract_features(image_paths, mre_lbp)

#     # Chuẩn bị dữ liệu huấn luyện
#     X_train, y_train = prepare_training_data(features, labels)

#     # Huấn luyện mô hình SVM
#     classifier = train_svm(X_train, y_train)

#     # Ghi giá trị trọng số và bias vào tệp
#     save_svm_weights_and_bias(classifier, filename="svm_weights_and_bias.txt")

#     # Đánh giá mô hình
#     accuracy = evaluate_model(classifier, X_train, y_train)
#     print(f"Training accuracy: {accuracy * 100:.2f}%")

def convert_to_fixed_point(value, q_format=22):
    """
    Chuyển đổi một giá trị float sang dạng fixed-point Q1.22.
    :param value: Giá trị float cần chuyển đổi.
    :param q_format: Số bit dành cho phần thập phân (mặc định là 22).
    :return: Giá trị fixed-point dưới dạng số nguyên 24-bit.
    """
    scale_factor = 2 ** q_format
    fixed_point_value = int(round(value * scale_factor))
    # Giới hạn giá trị trong phạm vi 24-bit (Q1.22)
    max_val = 2 ** 23 - 1  # Giá trị lớn nhất của Q1.22
    min_val = -2 ** 23     # Giá trị nhỏ nhất của Q1.22
    return max(min(fixed_point_value, max_val), min_val)


def save_svm_weights_and_bias_fixed_point_hex(classifier, filename="svm_weights_and_bias_fixed_point_hex.txt"):
    """
    Lưu trọng số và bias của SVM dưới dạng fixed-point Q1.22 và chuyển đổi sang dạng hex vào tệp.
    :param classifier: Mô hình SVM đã huấn luyện.
    :param filename: Tên tệp để lưu trọng số và bias.
    """
    def convert_to_fixed_point_hex(value, q_format=22):
        """
        Chuyển đổi một giá trị float sang dạng fixed-point Q1.22 và chuyển đổi sang hex.
        :param value: Giá trị float cần chuyển đổi.
        :param q_format: Số bit dành cho phần thập phân (mặc định là 22).
        :return: Giá trị fixed-point dưới dạng hex.
        """
        scale_factor = 2 ** q_format
        fixed_point_value = int(round(value * scale_factor))
        # Giới hạn giá trị trong phạm vi 24-bit (Q1.22)
        max_val = 2 ** 23 - 1  # Giá trị lớn nhất của Q1.22
        min_val = -2 ** 23     # Giá trị nhỏ nhất của Q1.22
        fixed_point_value = max(min(fixed_point_value, max_val), min_val)
        # Chuyển đổi sang hex (24-bit, có dấu)
        if fixed_point_value < 0:
            fixed_point_value = (1 << 24) + fixed_point_value  # Biểu diễn số âm trong 24-bit
        return f"0x{fixed_point_value:06X}"  # Định dạng hex 6 ký tự

    if hasattr(classifier, 'coef_') and hasattr(classifier, 'intercept_'):
        weights = classifier.coef_[0]  # Lấy trọng số (giả sử chỉ có một lớp)
        bias = classifier.intercept_[0]  # Lấy bias

        with open(filename, 'w') as f:
            # Lưu trọng số cho CI_0 và CI_1
            f.write("Weights for CI_0 and CI_1 (Fixed-Point Q1.22, Hex):\n")
            f.write(f"CI_0: {convert_to_fixed_point_hex(weights[0])}\n")
            f.write(f"CI_1: {convert_to_fixed_point_hex(weights[1])}\n\n")

            # Lưu trọng số cho NI và RD của từng bán kính
            offset = 2  # Bắt đầu từ vị trí thứ 2 (sau CI_0 và CI_1)
            radii = [2, 4, 6, 8]  # Các bán kính
            for r in radii:
                # Lưu trọng số cho NI của bán kính r
                f.write(f"Weights for NI (R={r}) (Fixed-Point Q1.22, Hex):\n")
                for i in range(256):  # 256 giá trị cho NI
                    f.write(f"{convert_to_fixed_point_hex(weights[offset + i])} ")
                f.write("\n\n")
                offset += 256

                # Lưu trọng số cho RD của bán kính r
                f.write(f"Weights for RD (R={r}) (Fixed-Point Q1.22, Hex):\n")
                for i in range(256):  # 256 giá trị cho RD
                    f.write(f"{convert_to_fixed_point_hex(weights[offset + i])} ")
                f.write("\n\n")
                offset += 256

            # Lưu bias
            f.write("Bias (Fixed-Point Q1.22, Hex):\n")
            f.write(f"{convert_to_fixed_point_hex(bias)}\n")

        print(f"Fixed-point weights and bias (Hex) saved to {filename}")
    else:
        print("The classifier does not have accessible weights and bias (non-linear kernel).")


def calculate_regions_by_label(X_train, y_train, classifier):
    """
    Tính và in ra các vùng giá trị của y_train tương ứng với từng nhãn.
    :param X_train: Dữ liệu huấn luyện (đặc trưng).
    :param y_train: Nhãn tương ứng với dữ liệu huấn luyện.
    :param classifier: Mô hình SVM đã huấn luyện.
    """
    # Tính giá trị dự đoán (decision function) cho từng mẫu
    decision_values = classifier.decision_function(X_train)

    # Lấy danh sách các nhãn duy nhất
    unique_labels = sorted(set(y_train))

    print("Regions by label:")
    for label in unique_labels:
        # Lấy các giá trị dự đoán tương ứng với nhãn hiện tại
        label_decision_values = decision_values[y_train == label]

        # Xác định khoảng giá trị (min, max) của y_train cho nhãn này
        min_value = label_decision_values.min()
        max_value = label_decision_values.max()

        print(f"Label '{label}': [{min_value:.2f}, {max_value:.2f}]")


if __name__ == "__main__":
    # Đường dẫn đến thư mục chứa các thư mục con của hình ảnh
    root_dir = "D:/Capstone/Texture regconition based FPGAs/mrelbp+svm/COMP3200-Texture-Classification/data/kylberg-rotated"

    # Đọc các tệp hình ảnh và nhãn, cân bằng số lượng ảnh giữa các nhãn
    image_paths, labels = load_balanced_image_paths_and_labels(root_dir)

    # Khởi tạo đối tượng MedianRobustExtendedLBP
    r1 = [2, 4, 6, 8]
    p = 8
    w_center = 3
    w_r1 = [3, 5, 7, 9]
    save_img = False

    mre_lbp = MedianRobustExtendedLBP(r1=r1, p=p, w_center=w_center, w_r1=w_r1, save_img=save_img)

    # Trích xuất các đặc trưng bằng MRELBP
    # features = extract_features(image_paths, mre_lbp)
    # features = extract_features_parallel(image_paths, mre_lbp, batch_size=64)
    features = extract_features_parallel_with_progress(image_paths, mre_lbp, max_workers=4)

    # Chuẩn bị dữ liệu huấn luyện
    X_train, y_train = prepare_training_data(features, labels)

    # Huấn luyện mô hình SVM
    classifier = train_svm_optimized(X_train, y_train)

    # Lưu trọng số và bias dưới dạng fixed-point Q1.22
    save_svm_weights_and_bias_fixed_point_hex(classifier, filename="svm_weights_and_bias_fixed_point_hex.txt")
    # Tính và in ra các vùng giá trị của y_train
    calculate_regions_by_label(X_train, y_train, classifier)