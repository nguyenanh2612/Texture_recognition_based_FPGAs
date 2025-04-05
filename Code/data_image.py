from PIL import Image
import numpy as np

# Mở ảnh
image_path = 'D:/Capstone/Texture regconition based FPGAs/mrelbp+svm/COMP3200-Texture-Classification/data/kylberg-rotated/ceiling/ceiling1-a-p001-r030.png'  # Đường dẫn tới ảnh của bạn
image = Image.open(image_path)

# Chuyển ảnh sang grayscale
grayscale_image = image.convert('L')

# Thay đổi kích thước ảnh thành 128x128
resized_image = grayscale_image.resize((128, 128))

# Chuyển ảnh thành ma trận NumPy
image_array = np.array(resized_image)

# Mở file để ghi
with open('image_matrix_hex.txt', 'w') as f:
    # Ghi ma trận vào file dưới dạng hex
    for row in image_array:
        hex_row = [hex(val) for val in row]  # Chuyển mỗi giá trị thành hex
        f.write(' '.join(hex_row) + '\n')  # Ghi từng hàng vào file

print("Đã ghi ma trận vào file 'image_matrix_hex.txt' dưới dạng hex.")

# Đọc file chứa giá trị hex và chuyển đổi thành bit
def hex_to_bit(input_file, output_file):
    with open(input_file, 'r') as f:
        # Đọc tất cả các dòng trong file
        hex_data = f.readlines()

    # Mở file output để ghi kết quả dưới dạng bit
    with open(output_file, 'w') as f_out:
        for line in hex_data:
            # Tách các giá trị hex theo khoảng trắng
            hex_values = line.split()

            # Chuyển đổi mỗi giá trị hex thành bit và ghi vào file
            for hex_val in hex_values:
                # Chuyển hex thành số nguyên và sau đó chuyển thành chuỗi nhị phân 8-bit
                bit_val = bin(int(hex_val, 16))[2:].zfill(8)
                f_out.write(bit_val + ' ')  # Ghi giá trị bit vào file
            f_out.write('\n')  # Mỗi dòng mới của hex sẽ là một dòng mới trong file

    print(f"File đã được chuyển đổi và ghi vào {output_file}")

# Đường dẫn đến file hex và file output
input_file = 'image_matrix_hex.txt'  # File chứa giá trị hex
output_file = 'image_matrix_bit.txt'  # File để ghi giá trị bit

# Chuyển hex thành bit
hex_to_bit(input_file, output_file)

def extract_sub_images(input_file, output_file, sub_size=9):
    """
    Extract sub-images of size sub_size x sub_size from a hex matrix file.
    :param input_file: Path to the input file containing the hex matrix.
    :param output_file: Path to the output file to save the sub-images.
    :param sub_size: Size of the sub-image (default is 9x9).
    """
    with open(input_file, 'r') as f:
        # Đọc ma trận hex từ file
        hex_matrix = [line.strip().split() for line in f.readlines()]

    # Chuyển đổi ma trận hex thành số nguyên
    int_matrix = [[int(val, 16) for val in row] for row in hex_matrix]

    # Kích thước của ma trận
    rows = len(int_matrix)
    cols = len(int_matrix[0])

    # Mở file để ghi các sub-image
    with open(output_file, 'w') as f_out:
        # Duyệt qua ma trận để lấy các sub-image
        for i in range(0, rows - sub_size + 1):
            for j in range(0, cols - sub_size + 1):
                # Lấy sub-image 9x9
                sub_image = [row[j:j + sub_size] for row in int_matrix[i:i + sub_size]]

                # Ghi sub-image vào file
                f_out.write(f"Sub-image at ({i}, {j}):\n")
                for sub_row in sub_image:
                    hex_row = [hex(val) for val in sub_row]  # Chuyển giá trị thành hex
                    f_out.write(' '.join(hex_row) + '\n')
                f_out.write('\n')  # Ngăn cách giữa các sub-image

    print(f"Đã trích xuất các sub-image 9x9 và ghi vào {output_file}")


# Đường dẫn đến file hex và file output
input_file = 'image_matrix_hex.txt'  # File chứa ma trận hex
output_file = 'sub_images_9x9.txt'  # File để ghi các sub-image

# Gọi hàm để trích xuất sub-image
extract_sub_images(input_file, output_file)

def parse_sub_images(input_file):
    """
    Generator để đọc và trả về từng sub-image từ file.
    """
    with open(input_file, 'r') as f:
        current_key = None
        current_image = []

        for line in f:
            line = line.strip()
            if line.startswith("Sub-image at"):
                if current_key is not None:
                    yield current_key, current_image
                current_key = tuple(map(int, line.split('(')[1].split(')')[0].split(',')))
                current_image = []
            elif line:
                current_image.append(line)
        if current_key is not None:
            yield current_key, current_image


def extract_all_sub_images(input_file, output_file, order, grid_size=120):
    """
    Extract all sub-images from a 120x120 grid in batches of 36 sub-images.
    :param input_file: Path to the input file containing sub-images.
    :param output_file: Path to the output file to save extracted sub-images.
    :param order: List of (row, col) tuples specifying the order of extraction.
    :param grid_size: Size of the grid (default is 120x120).
    """
    # Tạo danh sách các sub-images đã xử lý
    extracted_positions = set()

    # Tạo chỉ mục sub-images từ file
    sub_image_index = {}
    for key, sub_image in parse_sub_images(input_file):
        sub_image_index[key] = sub_image

    # Mở file output để ghi
    with open(output_file, 'w') as f_out:
        batch_number = 1
        while len(extracted_positions) < grid_size * grid_size:  # Tiếp tục cho đến khi xử lý hết 120x120 sub-images
            batch = []
            for base_row in range(0, grid_size, 6):  # Duyệt qua các khối 6x6
                for base_col in range(0, grid_size, 6):
                    for offset_row, offset_col in order:
                        row = base_row + offset_row
                        col = base_col + offset_col
                        if (row, col) in sub_image_index and (row, col) not in extracted_positions:
                            batch.append((row, col))
                            extracted_positions.add((row, col))
                            # Ghi sub-image vào file
                            f_out.write(f"Batch {batch_number} - Sub-image at ({row}, {col}):\n")
                            f_out.write('\n'.join(sub_image_index[(row, col)]) + '\n\n')
                        if len(batch) == 36:  # Đủ 36 sub-images cho một batch
                            break
                    if len(batch) == 36:
                        break
                if len(batch) == 36:
                    break
            batch_number += 1

    print(f"Đã trích xuất tất cả sub-images và ghi vào {output_file}")


# Thứ tự lấy sub-images
order = [
    (0, 0), (0, 1), (1, 0), (1, 1), (0, 2), (0, 3), (1, 2), (1, 3),
    (0, 4), (0, 5), (1, 4), (1, 5), (2, 0), (2, 1), (3, 0), (3, 1),
    (2, 2), (2, 3), (3, 2), (3, 3), (2, 4), (2, 5), (3, 4), (3, 5),
    (4, 0), (4, 1), (5, 0), (5, 1), (4, 2), (4, 3), (5, 2), (5, 3),
    (4, 4), (4, 5), (5, 4), (5, 5)
]

# Đường dẫn file input và output
input_file = 'sub_images_9x9.txt'
output_file = 'extracted_sub_images.txt'

# Gọi hàm để trích xuất sub-images
extract_all_sub_images(input_file, output_file, order)

def get_batch_data(input_file, batch_number):
    """
    Lấy toàn bộ dữ liệu của một batch cụ thể từ file.
    :param input_file: Đường dẫn đến file chứa các batch.
    :param batch_number: Số thứ tự của batch cần lấy dữ liệu.
    :return: Dữ liệu của batch dưới dạng danh sách các dòng.
    """
    current_batch = None
    current_content = []
    is_in_batch = False

    with open(input_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith("Batch"):
                current_batch = int(line.split()[1])  # Lấy số thứ tự batch
                is_in_batch = (current_batch == batch_number)  # Kiểm tra nếu là batch cần tìm
            if is_in_batch:
                current_content.append(line)
            elif current_batch == batch_number and line == "":  # Kết thúc batch
                break

    return current_content

def reorder_batches(input_file, output_file, total_batches=400, batches_per_row=20):
    """
    Sắp xếp lại các batch theo thứ tự xen kẽ giữa các hàng và cột.
    :param input_file: Đường dẫn đến file chứa các batch.
    :param output_file: Đường dẫn đến file output.
    :param total_batches: Tổng số batch (mặc định là 400).
    :param batches_per_row: Số batch trên mỗi hàng (mặc định là 20).
    """
    # Tạo thứ tự sắp xếp theo yêu cầu
    reordered = []
    for base_row in range(0, total_batches, batches_per_row * 3):  # Duyệt qua từng nhóm hàng (3 hàng mỗi nhóm)
        for base_col in range(0, batches_per_row, 3):  # Duyệt qua từng nhóm cột (3 cột mỗi nhóm)
            for offset_row in range(3):  # Duyệt qua từng hàng trong nhóm
                for offset_col in range(3):  # Duyệt qua từng cột trong nhóm
                    batch_number = base_row + base_col + offset_row * batches_per_row + offset_col + 1
                    if batch_number <= total_batches:
                        reordered.append(batch_number)

    # Ghi dữ liệu đã sắp xếp vào file output
    with open(output_file, 'w') as f_out:
        for batch_number in reordered:
            # Lấy dữ liệu của batch
            batch_data = get_batch_data(input_file, batch_number)
            if batch_data:  # Kiểm tra nếu batch có dữ liệu
                f_out.write('\n'.join(batch_data) + '\n\n')

    print(f"Đã sắp xếp lại các batch và ghi vào {output_file}")


# Đường dẫn file input và output
input_file = 'extracted_sub_images.txt'
output_file = 'reordered_sub_images.txt'

# Gọi hàm để sắp xếp lại các batch
reorder_batches(input_file, output_file)

def extract_hex_data(input_file, intermediate_file, output_file):
    """
    Đọc dữ liệu từ file, loại bỏ chữ và chỉ giữ lại giá trị hex, sau đó ghi mỗi giá trị hex vào một dòng.
    :param input_file: Đường dẫn đến file chứa dữ liệu ban đầu (reordered_sub_images.txt).
    :param intermediate_file: File trung gian để lưu dữ liệu hex đã loại bỏ chữ.
    :param output_file: File cuối cùng để ghi mỗi giá trị hex trên một dòng.
    """
    # Bước 1: Loại bỏ chữ và chỉ giữ lại dữ liệu hex
    with open(input_file, 'r') as f_in, open(intermediate_file, 'w') as f_intermediate:
        for line in f_in:
            line = line.strip()
            # Bỏ qua các dòng tiêu đề hoặc dòng trống
            if line.startswith("Batch") or line.startswith("Sub-image at") or line == "":
                continue
            # Ghi dữ liệu hex vào file trung gian
            f_intermediate.write(line + '\n')

    # Bước 2: Ghi từng giá trị hex vào một dòng trong file output
    with open(intermediate_file, 'r') as f_intermediate, open(output_file, 'w') as f_out:
        for line in f_intermediate:
            hex_values = line.split()  # Tách các giá trị hex trong dòng
            for hex_val in hex_values:
                f_out.write(hex_val + '\n')  # Ghi mỗi giá trị hex trên một dòng

    print(f"Đã xử lý dữ liệu và ghi vào {output_file}")


# Đường dẫn file input, file trung gian và file output
input_file = 'reordered_sub_images.txt'  # File chứa dữ liệu ban đầu
intermediate_file = 'hex_only_data.txt'  # File trung gian để lưu dữ liệu hex
output_file = 'hex_values_per_line.txt'  # File cuối cùng chứa mỗi giá trị hex trên một dòng

# Gọi hàm để xử lý dữ liệu
extract_hex_data(input_file, intermediate_file, output_file)

def check_data_consistency(reordered_file, hex_values_file):
    """
    Kiểm tra tính nhất quán giữa dữ liệu trong file reordered_sub_images.txt và hex_values_per_line.txt.
    :param reordered_file: Đường dẫn đến file reordered_sub_images.txt.
    :param hex_values_file: Đường dẫn đến file hex_values_per_line.txt.
    :return: True nếu dữ liệu khớp, False nếu không.
    """
    # Đọc dữ liệu từ file reordered_sub_images.txt
    reordered_hex_values = []
    with open(reordered_file, 'r') as f_reordered:
        for line in f_reordered:
            line = line.strip()
            # Bỏ qua các dòng tiêu đề hoặc dòng trống
            if line.startswith("Batch") or line.startswith("Sub-image at") or line == "":
                continue
            # Thêm dữ liệu hex vào danh sách
            reordered_hex_values.extend(line.split())

    # Đọc dữ liệu từ file hex_values_per_line.txt
    with open(hex_values_file, 'r') as f_hex_values:
        hex_values = [line.strip() for line in f_hex_values if line.strip()]

    # So sánh dữ liệu
    if reordered_hex_values == hex_values:
        print("Dữ liệu trong hai file KHỚP nhau.")
        return True
    else:
        print("Dữ liệu trong hai file KHÔNG KHỚP nhau.")
        return False


# Đường dẫn đến file reordered_sub_images.txt và hex_values_per_line.txt
reordered_file = 'reordered_sub_images.txt'
hex_values_file = 'hex_values_per_line.txt'

# Gọi hàm để kiểm tra tính nhất quán
check_data_consistency(reordered_file, hex_values_file)

def remove_hex_prefix(input_file, output_file):
    """
    Loại bỏ tiền tố '0x' khỏi tất cả các giá trị hex trong file.
    :param input_file: Đường dẫn đến file chứa dữ liệu hex ban đầu.
    :param output_file: Đường dẫn đến file để ghi dữ liệu đã loại bỏ '0x'.
    """
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            # Loại bỏ tiền tố '0x' khỏi mỗi giá trị hex
            cleaned_line = line.strip().replace('0x', '')
            if cleaned_line:  # Chỉ ghi nếu dòng không rỗng
                f_out.write(cleaned_line + '\n')

    print(f"Đã loại bỏ tiền tố '0x' và ghi dữ liệu vào {output_file}")


# Đường dẫn file input và output
input_file = 'hex_values_per_line.txt'  # File chứa dữ liệu hex ban đầu
output_file = 'D:/Capstone/Texture regconition based FPGAs/code/test_step/MRELP/02_sim/pixel_input.dump'  # File để ghi dữ liệu đã loại bỏ '0x'

# Gọi hàm để xử lý dữ liệu
remove_hex_prefix(input_file, output_file)