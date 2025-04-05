module lut_ni_2(
    input  logic [7:0]                i_addr,
    output logic [23:0]               o_dout
);

    // Khởi tạo giá trị cho mảng "mem" bên trong initial block
    logic [23:0] mem [255:0];

    initial begin
        $readmemh("D:/Capstone/Texture regconition based FPGAs/code/test_step/MRELP/02_sim/ni_2_weight.dump", mem); // Đọc dữ liệu từ file "mem.txt" và lưu vào mảng "mem"
    end

    assign o_dout = mem[i_addr]; // Cắt giảm i_addr để tránh chỉ số vượt quá phạm vi
endmodule
