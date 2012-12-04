module encoder(
clock_me,
encode_en,
rst_n,
pixel_data,
R,
G,
B);

input clock_me;
input encode_en;
input rst_n;
input [23:0] pixel_data;
output[9:0] R;
output[9:0] G;
output[9:0] B;

encoder_one encode_R(clock_me,encode_en,rst_n,pixel_data[7:0],R);
encoder_one encode_G(clock_me,encode_en,rst_n,pixel_data[15:8], G);
encoder_one encode_B(clock_me,encode_en,rst_n,pixel_data[23:16],B);

endmodule
