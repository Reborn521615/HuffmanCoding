`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/05 09:53:40
// Design Name: 
// Module Name: encoding
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module encoding(
    input clk,
    input rst_n,
    input data_count_finish,
    input [4:0]min1,
    input [4:0]min2,
    
    output [4:0]new_root_index,   //��־���������ɸ���λ��    
    
    output encoding_finish,
    output reg [8:0]code_mask_0 = 0,    //���ݱ��볤��
    output reg [8:0]code_mask_1 = 0,
    output reg [8:0]code_mask_2 = 0,
    output reg [8:0]code_mask_3 = 0,
    output reg [8:0]code_mask_4 = 0,
    output reg [8:0]code_mask_5 = 0,
    output reg [8:0]code_mask_6 = 0,
    output reg [8:0]code_mask_7 = 0,
    output reg [8:0]code_mask_8 = 0,
    output reg [8:0]code_mask_9 = 0,
    output reg [8:0]code_0 = 0,           //���ݱ��� 
    output reg [8:0]code_1 = 0,   
    output reg [8:0]code_2 = 0,    
    output reg [8:0]code_3 = 0,    
    output reg [8:0]code_4 = 0,    
    output reg [8:0]code_5 = 0,     
    output reg [8:0]code_6 = 0,
    output reg [8:0]code_7 = 0,     
    output reg [8:0]code_8 = 0,   
    output reg [8:0]code_9 = 0    
    
    );
    
    reg [4:0] new_root_index_r = 5'd10;   //��־���������ɸ���λ��    
    reg [3:0] code_count = 4'b0000;
    reg encoding_finish_r = 1'b0;    //������ɱ�־
    wire [9:0] add0_mask; //��0����
    wire [9:0] add1_mask; //��1����
    reg [9:0] tree [18:0];   //������

    assign new_root_index = new_root_index_r;
    assign encoding_finish = encoding_finish_r;
    
    assign add0_mask=tree[min1];
    assign add1_mask=tree[min2];
    
    always @(posedge clk)   
    begin
        if(rst_n == 1'b0) 
          begin  //��ʼ��ʱִ��һ��
              code_count <= 0;         //�����������
              encoding_finish_r <= 0;    //������ɱ�־����
              new_root_index_r = 5'd10;  //��ʼ����־���������ɸ���λ��
    
              tree[0]<=10'b00000_00001;
              tree[1]<=10'b00000_00010;
              tree[2]<=10'b00000_00100;
              tree[3]<=10'b00000_01000;
              tree[4]<=10'b00000_10000;
              tree[5]<=10'b00001_00000;
              tree[6]<=10'b00010_00000;
              tree[7]<=10'b00100_00000;
              tree[8]<=10'b01000_00000;
              tree[9]<=10'b10000_00000;
              //i=10~18Ϊ֦��
              tree[10]<=10'b00000_00000;
              tree[11]<=10'b00000_00000;
              tree[12]<=10'b00000_00000;
              tree[13]<=10'b00000_00000;
              tree[14]<=10'b00000_00000;
              tree[15]<=10'b00000_00000;
              tree[16]<=10'b00000_00000;
              tree[17]<=10'b00000_00000;
              tree[18]<=10'b00000_00000;
          end
        else
          begin

           if(data_count_finish==1'b1 && code_count < 8)  //���������������߽�������7��ʼ�Ų����������
              begin    //���������������
                  code_count <= code_count + 1;
                  tree[new_root_index_r]<=tree[min1] | tree[min2]; //�����½ڵ㣬��λ��������Ž���������
                  new_root_index_r <= new_root_index_r + 1'b1;
              end  
            else if(data_count_finish==1'b1 && code_count >= 8 && code_count < 9)  
              begin
                  tree[new_root_index_r]<=tree[min1] | tree[min2]; //�����½ڵ㣬��λ��������Ž���������
                  new_root_index_r <= new_root_index_r + 1'b1;
                  code_count <= code_count + 1;
                  encoding_finish_r <= 1;         //Ϊ������������㲻�˷�ʱ�ӣ��Ĵ����ش�����ɵ��ӳ٣���������ǰ�������ʱ�ӣ�ʵ���ϲ�û�����
              end  
            else if(data_count_finish==1'b1 && code_count == 9) 
              begin
                  encoding_finish_r <= 1;
              end     
            else
              begin
                    encoding_finish_r <= 0;
              end  
          end
    end

    //����ĳ��������������յı���
    
    
    always @(posedge clk)   //����0�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9)   //����������ԣ��������ڵȴ�ʱ�Ӷ���9������ͬ
          begin                                                              
            if(add0_mask[0] == 1'b1) 
              begin
                code_0[8:0] <= {1'b0,code_0[8:1]};
                //code_mask_0 <= code_mask_0 + 1;
                code_mask_0<={1'b1,code_mask_0[8:1]};
              end
            else if(add1_mask[0] == 1'b1)     //��һ��else��֪�� ��û�����⣬��ʱ��������һ�£�����������������������ͬ
              begin
                code_0 <= {1'b1,code_0[8:1]};
                //code_mask_0 <= code_mask_0 + 1;
                code_mask_0<={1'b1,code_mask_0[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����1�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[1] == 1'b1) 
              begin
                //code_mask_1 <= code_mask_1 + 1;
                code_1 <= {1'b0,code_1[8:1]};
                code_mask_1<={1'b1,code_mask_1[8:1]};
              end
            else if(add1_mask[1] == 1'b1) 
              begin
                //code_mask_1 <= code_mask_1 + 1;
                code_1 <= {1'b1,code_1[8:1]};
                code_mask_1<={1'b1,code_mask_1[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����2�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[2] == 1'b1) 
              begin
                //code_mask_2 <= code_mask_2 + 1;
                code_2 <= {1'b0,code_2[8:1]};
                code_mask_2<={1'b1,code_mask_2[8:1]};
              end
            else if(add1_mask[2] == 1'b1)  
              begin
                //code_mask_2 <= code_mask_2 + 1;
                code_2 <= {1'b1,code_2[8:1]};
                code_mask_2<={1'b1,code_mask_2[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����3�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9)
          begin
            if(add0_mask[3] == 1'b1) 
              begin
                //code_mask_3 <= code_mask_3 + 1;
                code_3 <= {1'b0,code_3[8:1]};
                code_mask_3<={1'b1,code_mask_3[8:1]};
              end
            else if(add1_mask[3] == 1'b1)
              begin
                //code_mask_3 <= code_mask_3 + 1;
                code_3 <= {1'b1,code_3[8:1]};
                code_mask_3<={1'b1,code_mask_3[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����4�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9)
          begin
            if(add0_mask[4] == 1'b1) 
              begin
                //code_mask_4 <= code_mask_4 + 1;
                code_4 <= {1'b0,code_4[8:1]};
                code_mask_4<={1'b1,code_mask_4[8:1]};
              end
            else if(add1_mask[4] == 1'b1)
              begin
                //code_mask_4 <= code_mask_4 + 1;
                code_4 <= {1'b1,code_4[8:1]};
                code_mask_4<={1'b1,code_mask_4[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����5�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[5] == 1'b1) 
              begin
                //code_mask_5 <= code_mask_5 + 1;
                code_5 <= {1'b0,code_5[8:1]};
                code_mask_5<={1'b1,code_mask_5[8:1]};
              end
            else if(add1_mask[5] == 1'b1) 
              begin
                //code_mask_5 <= code_mask_5 + 1;
                code_5 <= {1'b1,code_5[8:1]};
                code_mask_5<={1'b1,code_mask_5[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����6�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[6] == 1'b1)
              begin
                //code_mask_6 <= code_mask_6 + 1;
                code_6 <= {1'b0,code_6[8:1]};
                code_mask_6<={1'b1,code_mask_6[8:1]};
              end
            else if(add1_mask[6] == 1'b1) 
              begin
                //code_mask_6 <= code_mask_6 + 1;
                code_6 <= {1'b1,code_6[8:1]};
                code_mask_6<={1'b1,code_mask_6[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����7�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[7] == 1'b1) 
              begin
                //code_mask_7 <= code_mask_7 + 1;
                code_7 <= {1'b0,code_7[8:1]};
                code_mask_7<={1'b1,code_mask_7[8:1]};
              end
            else if(add1_mask[7] == 1'b1)
              begin
                //code_mask_7 <= code_mask_7 + 1;
                code_7 <= {1'b1,code_7[8:1]};
                code_mask_7<={1'b1,code_mask_7[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����8�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[8] == 1'b1)
              begin
                //code_mask_8 <= code_mask_8 + 1;
                code_8 <= {1'b0,code_8[8:1]};
                code_mask_8<={1'b1,code_mask_8[8:1]};
              end
            else if(add1_mask[8] == 1'b1) 
              begin
                //code_mask_8 <= code_mask_8 + 1;
                code_8 <= {1'b1,code_8[8:1]};
                code_mask_8<={1'b1,code_mask_8[8:1]};
              end
          end
    end
    
    always @(posedge clk) //����9�ı���
    begin
        if(data_count_finish == 1'b1 && code_count < 9) 
          begin
            if(add0_mask[9] == 1'b1) 
              begin
                //code_mask_9 <= code_mask_9 + 1;
                code_9 <= {1'b0,code_9[8:1]};
                code_mask_9<={1'b1,code_mask_9[8:1]};
              end
            else if(add1_mask[9] == 1'b1) 
              begin
                //code_mask_9 <= code_mask_9 + 1;
                code_9 <= {1'b1,code_9[8:1]};
                code_mask_9<={1'b1,code_mask_9[8:1]};
              end
          end
    end
endmodule
