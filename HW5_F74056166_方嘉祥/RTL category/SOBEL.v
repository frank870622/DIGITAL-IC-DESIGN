
`timescale 1ns/10ps

module  SOBEL(clk,reset,busy,ready,iaddr,idata,cdata_rd,cdata_wr,caddr_rd,caddr_wr,cwr,crd,csel	);
	input				clk;
	input				reset;
	output	reg			busy;	
	input				ready;	
	output 	reg [16:0]		iaddr;
	input  	[7:0]		idata;	
	input	[7:0]		cdata_rd;
	output	reg [7:0]		cdata_wr;
	output 	reg [15:0]		caddr_rd;
	output 	reg [15:0]		caddr_wr;
	output	reg			cwr,crd;
	output 	reg [1:0]		csel;

	reg [5:0] state;

	parameter state_start = 0;
	parameter state_input_gray_start = 1;
	parameter state_input_gray_1 = 2;
	parameter state_input_gray_2 = 3;
	parameter state_input_gray_3 = 4;
	parameter state_input_gray_4 = 5;
	parameter state_input_gray_5 = 6;
	parameter state_input_gray_6 = 7;
	parameter state_input_gray_7 = 8;
	parameter state_input_gray_8 = 9;
	parameter state_input_gray_9 = 10;
	parameter state_output_x = 11;
	parameter state_output_y = 12;
	parameter state_output_sobel = 13;
	parameter state_next_read_gray = 14;
	parameter state_finish = 15;


	integer img_x, img_y;
	integer sobel_x_cal, sobel_y_cal;

	initial 
	begin
		img_x <= 0;
		img_y <= 0;
		sobel_x_cal <= 0;
		sobel_y_cal <= 0;
		iaddr <= 0;
		busy <= 0;
	end

	always@(posedge clk, posedge reset)
	begin
		if(reset)
		begin
			state <= state_start;

			img_x <= 0;
			img_y <= 0;
			sobel_x_cal <= 0;
			sobel_y_cal <= 0;

			busy <= 0;
			iaddr <= 0;
			cdata_wr <= 0;
			caddr_wr <= 0;
			caddr_rd <= 0;
			cwr <= 0;
			crd <= 0;
			csel <= 0;
		end
		else
		begin
			if(state == state_start && ready == 1)
			begin
				busy <= 1;
				state <= state_input_gray_start;
			end
			else if(state == state_input_gray_start)
			begin
				iaddr <= ((img_y)*258) + (img_x);

				state <= state_input_gray_1;
			end
			else if(state == state_input_gray_1)
			begin
				iaddr <= ((img_y)*258) + (img_x + 1);
				sobel_x_cal <= sobel_x_cal + idata;
				sobel_y_cal <= sobel_y_cal + idata;

				state <= state_input_gray_2;
			end
			else if(state == state_input_gray_2)
			begin
				iaddr <= ((img_y)*258) + (img_x + 2);
				sobel_x_cal <= sobel_x_cal;
				sobel_y_cal <= sobel_y_cal + (idata + idata);

				state <= state_input_gray_3;
			end
			else if(state == state_input_gray_3)
			begin
				iaddr <= ((img_y + 1)*258) + (img_x);
				sobel_x_cal <= sobel_x_cal - idata;
				sobel_y_cal <= sobel_y_cal + idata;

				state <= state_input_gray_4;
			end
			else if(state == state_input_gray_4)
			begin
				iaddr <= ((img_y + 1)*258) + (img_x + 1);
				sobel_x_cal <= sobel_x_cal + (idata + idata);
				sobel_y_cal <= sobel_y_cal;

				state <= state_input_gray_5;
			end
			else if(state == state_input_gray_5)
			begin
				iaddr <= ((img_y + 1)*258) + (img_x + 2);
				sobel_x_cal <= sobel_x_cal;
				sobel_y_cal <= sobel_y_cal;

				state <= state_input_gray_6;
			end
			else if(state == state_input_gray_6)
			begin
				iaddr <= ((img_y + 2)*258) + (img_x);
				sobel_x_cal <= sobel_x_cal - (idata + idata);
				sobel_y_cal <= sobel_y_cal;

				state <= state_input_gray_7;
			end
			else if(state == state_input_gray_7)
			begin
				iaddr <= ((img_y + 2)*258) + (img_x + 1);
				sobel_x_cal <= sobel_x_cal + idata;
				sobel_y_cal <= sobel_y_cal - idata;

				state <= state_input_gray_8;
			end
			else if(state == state_input_gray_8)
			begin
				iaddr <= ((img_y + 2)*258) + (img_x + 2);
				sobel_x_cal <= sobel_x_cal;
				sobel_y_cal <= sobel_y_cal - (idata + idata);

				state <= state_input_gray_9;
			end
			else if(state == state_input_gray_9)
			begin
				iaddr <= 0;
				sobel_x_cal <= sobel_x_cal - idata;
				sobel_y_cal <= sobel_y_cal - idata;

				state <= state_output_x;
			end
			else if(state == state_output_x)
			begin
				cwr <= 1;
				if(sobel_x_cal > 255)
				begin
					cdata_wr <= 255;
					sobel_x_cal <= 255;
				end
				else if(sobel_x_cal < 0)
				begin
					cdata_wr <= 0;
					sobel_x_cal <= 0;
				end
				else
				begin
					cdata_wr <= sobel_x_cal;
				end
				caddr_wr <= (256 * img_y) + img_x;
				csel <= 2'b01;

				state <= state_output_y;
			end
			else if(state == state_output_y)
			begin
				cwr <= 1;
				if(sobel_y_cal > 255)
				begin
					cdata_wr <= 255;
					sobel_y_cal <= 255;
				end
				else if(sobel_y_cal < 0)
				begin
					cdata_wr <= 0;
					sobel_y_cal <= 0;
				end
				else
				begin
					cdata_wr <= sobel_y_cal;
				end
				caddr_wr <= (256 * img_y) + img_x;
				csel <= 2'b10;

				state <= state_output_sobel;
			end
			else if(state == state_output_sobel)
			begin
				cwr <= 1;

				cdata_wr <= ((sobel_x_cal + sobel_y_cal) + 1) / 2;
				caddr_wr <= (256 * img_y) + img_x;

				csel <= 2'b11;

				state <= state_next_read_gray;
			end
			else if(state == state_next_read_gray)
			begin
				if(img_x == 255 && img_y == 255)
				begin
					img_x <= 0;
					img_y <= 0;
					state <= state_finish;
				end
				else if(img_x == 255)
				begin
					img_x <= 0;
					img_y <= img_y + 1;

					state <= state_input_gray_start;
				end
				else
				begin
					img_x <= img_x + 1;

					state <= state_input_gray_start;
				end

				iaddr <= 0;

				sobel_x_cal <= 0;
				sobel_y_cal <= 0;

				cwr <= 0;
				cdata_wr <= 0;
				caddr_wr <= 0;
				csel <= 0;
			end
			else if(state == state_finish)
			begin
				busy <= 0;
			end
			else
			begin
			end
		end
	end	
	
endmodule




