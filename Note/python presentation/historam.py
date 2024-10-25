import cv2
import numpy as np
from skimage import feature
import matplotlib.pyplot as plt

# Load the image
image_path = 'd:/Capstone/Texture regconition based FPGAs/Texture_recognition_based_FPGAs/Note/python presentation/test.jpg'  # Update this with the correct path if needed
image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)

# Check if the image was loaded correctly
if image is None:
    print(f"Error: Unable to load image at '{image_path}'. Please check the path.")
else:
    # Compute the LBP
    lbp = feature.local_binary_pattern(image, P=8, R=1, method='uniform')

    # Compute the histogram
    # Update the number of bins according to the number of LBP values
    num_bins = int(lbp.max() + 1)  # Should match the number of unique LBP values
    hist, _ = np.histogram(lbp.ravel(), bins=num_bins, range=(0, num_bins))

    # Normalize the histogram
    hist = hist.astype('float')
    hist /= hist.sum()

    # Print or plot the histogram
    print(hist)

    # Optional: Plotting the histogram
    plt.figure(figsize=(10, 5))
    plt.bar(range(num_bins), hist, width=1.0, edgecolor='black')
    plt.title('LBP Histogram')
    plt.xlabel('LBP Value')
    plt.ylabel('Frequency')
    plt.xlim([0, num_bins])
    plt.grid(axis='y')
    plt.show()
