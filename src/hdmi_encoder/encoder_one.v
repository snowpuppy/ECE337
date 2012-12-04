module encoder_one(
    clock_me,
    encode_en,
    rst_n,
    d,
    q_out);
  
    input rst_n;
    input clock_me;
    input encode_en;
    input[7:0] d;
    output reg[9:0] q_out;


    reg[8:0] q_m;
    reg[7:0] cnt;

    wire[3:0] num0d, num1d, num0q_m, num1q_m;
    numbercnt numbercnt_d_inst(d[7:0], num0d, num1d);
    numbercnt numbercnt_q_m_inst(q_m[7:0], num0q_m, num1q_m);
  
    always @(*)
    begin
        if((num1d > 8'h4) || ((num1d == 8'h4) && (d[0] == 1'b0)))
        begin
            q_m[0] = d[0];
            q_m[1] = q_m[0] ~^ d[1];
            q_m[2] = q_m[1] ~^ d[2];
            q_m[3] = q_m[2] ~^ d[3];
            q_m[4] = q_m[3] ~^ d[4];
            q_m[5] = q_m[4] ~^ d[5];
            q_m[6] = q_m[5] ~^ d[6];
            q_m[7] = q_m[6] ~^ d[7];
            q_m[8] = 1'b0;
        end
        else
        begin
            q_m[0] = d[0];
            q_m[1] = q_m[0] ^ d[1];
            q_m[2] = q_m[1] ^ d[2];
            q_m[3] = q_m[2] ^ d[3];
            q_m[4] = q_m[3] ^ d[4];
            q_m[5] = q_m[4] ^ d[5];
            q_m[6] = q_m[5] ^ d[6];
            q_m[7] = q_m[6] ^ d[7];
            q_m[8] = 1'b1;
        end
    end

    always @(posedge clock_me)
    begin
        if (rst_n == 0)
        begin
            q_out <= 10'b0000000000;
            cnt <= 8'h00;
        end
        else if(encode_en)
        begin
          ////////////////////////////////////////////////////////////////////////////////////////
            if((cnt == 8'h00) || (num1q_m == num0q_m))
            begin
                q_out[9] <= ~q_m[8];
                q_out[8] <= q_m[8];
                q_out[7:0] <= q_m[8] ? q_m[7:0] : ~q_m[7:0];
                if(q_m[8] == 1'b0)
                    cnt <= cnt + (num0q_m - num1q_m);
                else
                    cnt <= cnt + (num1q_m - num0q_m);
            	end

            else if(((cnt[7] == 1'b0) && (num1q_m > num0q_m)) || ((cnt[7] == 1'b1) && (num0q_m > num1q_m)))
            begin
                q_out[9] <= 1'b1;
                q_out[8] <= q_m[8];
                q_out[7:0] <= ~q_m[7:0];
                cnt <= cnt + (q_m[8] << 1) + (num0q_m - num1q_m);
            	end

            else            	
	          begin
                q_out[9] <= 1'b0;
                q_out[8] <= q_m[8];
                q_out[7:0] <= q_m[7:0];
                cnt <= cnt - (~q_m[8] << 1) + (num1q_m - num0q_m);
            	end
            ////////////////////////////////////////////////////////////////////////////////
           end
         end

endmodule
