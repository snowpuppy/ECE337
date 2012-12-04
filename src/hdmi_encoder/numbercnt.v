module numbercnt(
input wire [7:0] data_in,
output reg [3:0] num0,
output reg [3:0] num1);
integer k;

always @ (*)
begin
  num0 = 4'b0000;
  num1 = 4'b0000;
  for(k = 0; k < 8; k = k + 1) begin
    if(data_in[k] == 1'b1) begin
      num1 = num1 + 1;
    end
  else if(data_in[k] == 1'b0) 
    begin
      num0 = num0 + 1;
    end
    
  end 
  end
endmodule
  
      
