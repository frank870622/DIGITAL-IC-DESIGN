`timescale 1ns/10ps
module RC4(clk,rst,key_valid,key_in,plain_read,plain_in_valid,plain_in,plain_write,plain_out,cipher_write,cipher_out,cipher_read,cipher_in,cipher_in_valid,done);
    input clk,rst;
    input key_valid,plain_in_valid,cipher_in_valid;
    input [7:0] key_in,cipher_in,plain_in;
    output reg done;
    output reg plain_write,cipher_write,plain_read,cipher_read;
    output reg [7:0] cipher_out,plain_out;

    reg [7:0] key[31:0];
    reg [5:0] state;
    reg [7:0] S[63:0];
    reg [7:0] databox;
    //reg [6:0] count_key_input;
    integer i,j, count_key_input, count_create_Sbox, count_schedule;
    //integer S[63:0];

    parameter state_start = 0;
    parameter key_input_start = 1;
    parameter plain_input_start = 2;
    parameter plain_input_start2 = 3;
    parameter cipher_output_wait = 4;
    parameter cipher_output_start = 5;
    parameter cipher_input_start = 6;
    parameter cipher_input_start2 = 7;
    parameter plain_output_wait = 8;
    parameter plain_output_start = 9;
    parameter state_finish = 10;
    parameter create_Sbox = 11;
    parameter create_Sbox2 = 12;
    parameter schedule_Sbox = 13;
    parameter schedule_Sbox_part2 = 14;
    parameter schedule_Sbox2 = 15;
    parameter schedule_Sbox2_part2 = 16;


    always @(posedge clk)
    begin
        if(rst == 1)
        begin
            cipher_out <= 0;
            plain_out <= 0;

            plain_read <= 0;
            plain_write <= 0;
            cipher_read <= 0;
            cipher_write <= 0;
            done <= 0;

            i <= 0;
            j <= 0;
            databox <= 0;

            count_key_input <= 0;
            count_create_Sbox <= 0;
            count_schedule <= 0;
            state <= state_start;
        end
        else
        begin
            if(state == state_start && key_valid == 1)
            begin
                state <= key_input_start;
            end
            else
            begin
                case(state)
                    key_input_start:
                    begin
                        if(count_key_input < 32)
                        begin
                            key[count_key_input] <= key_in;
                            count_key_input <= count_key_input + 1;
                        end
                        else
                        begin
                            i <= 0;
                            j <= 0;
                            state <= create_Sbox;
                        end
                    end
                    create_Sbox:
                    begin   
                        if(count_create_Sbox < 64)
                        begin
                            S[count_create_Sbox] <= count_create_Sbox;
                            count_create_Sbox <= count_create_Sbox + 1;
                        end
                        else
                        begin
                            count_create_Sbox <= 0;

                            state <= schedule_Sbox;
                        end
                    end
                    schedule_Sbox:
                    begin
                        if(count_schedule < 64)
                        begin
                            j <= (j + S[count_schedule] + key[count_schedule % 32]) % 64;
                            state <= schedule_Sbox_part2;
                        end
                        else
                        begin
                            count_schedule <= 0;
                            i <= 0;
                            j <= 0;

                            state <= plain_input_start;
                        end
                    end
                    schedule_Sbox_part2:
                    begin
                        S[count_schedule] <= S[j];
                        S[j] <= S[count_schedule];
                        count_schedule <= count_schedule + 1;

                        state <= schedule_Sbox;
                    end
                    plain_input_start:
                    begin
                        i <= (i + 1) % 64;

                        state <= plain_input_start2;

                        cipher_write <= 0;
                    end
                    plain_input_start2:
                    begin
                        j <= (j + S[i]) % 64;

                        state <= cipher_output_wait;

                        plain_read <= 1;
                    end
                    cipher_output_wait:
                    begin
                        if(plain_in_valid == 1)
                        begin
                            S[i] <= S[j];
                            S[j] <= S[i];
                            databox <= plain_in;

                            state <= cipher_output_start;
                        end
                        else
                        begin
                            i <= 0;
                            j <= 0;
                            state <= create_Sbox2;
                        end
                        plain_read <= 0;
                    end
                    cipher_output_start:
                    begin
                        cipher_out <= databox ^ S[(S[i] + S[j]) % 64];

                        state <= plain_input_start;
                        
                        cipher_write <= 1;
                    end
                    create_Sbox2:
                    begin
                        if(count_create_Sbox < 64)
                        begin
                            S[count_create_Sbox] <= count_create_Sbox;
                            count_create_Sbox <= count_create_Sbox + 1;
                        end
                        else
                        begin
                            count_create_Sbox <= 0;

                            state <= schedule_Sbox2;
                        end
                    end
                    schedule_Sbox2:
                    begin
                        if(count_schedule < 64)
                        begin
                            j <= (j + S[count_schedule] + key[count_schedule % 32]) % 64;
                            state <= schedule_Sbox2_part2;
                        end
                        else
                        begin
                            count_schedule <= 0;
                            i <= 0;
                            j <= 0;

                            state <= cipher_input_start;
                        end
                    end
                    schedule_Sbox2_part2:
                    begin
                        S[count_schedule] <= S[j];
                        S[j] <= S[count_schedule];
                        count_schedule <= count_schedule + 1;

                        state <= schedule_Sbox2;
                    end
                    cipher_input_start:
                    begin
                        i <= (i + 1) % 64;

                        state <= cipher_input_start2;

                        plain_write <= 0;
                    end
                    cipher_input_start2:
                    begin
                        j <= (j + S[i]) % 64;

                        state <= plain_output_wait;

                        cipher_read <= 1;
                    end
                    plain_output_wait:
                    begin
                        if(cipher_in_valid == 1)
                        begin
                            S[i] <= S[j];
                            S[j] <= S[i];
                            databox <= cipher_in;

                            state <= plain_output_start;
                        end
                        else
                            state <= state_finish;
                        begin
                        end
                        cipher_read <= 0;
                    end
                    plain_output_start:
                    begin
                        plain_out <= databox ^ S[(S[i] + S[j]) % 64];

                        state <= cipher_input_start;

                        plain_write <= 1;
                    end
                    state_finish:
                    begin
                        done <= 1;
                    end
                    default:
                    begin
                    end
                endcase
            end
        end
    end

endmodule
