`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/05 09:54:54
// Design Name: 
// Module Name: data_store
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

//��ģ�������洢�������ݣ������������ݽ���Ƶ��ͳ�Ʋ������ʼƵ��
module data_store(
    input clk,    //��������ʱ��
    input rst_n,  //��λ�ź�
    input start,  //��ʼ����ı�־�ź�
    input [3:0]data_in, //��������
    input data_out_start,  //��ʼ����洢�����ݵı�־
    
    input [8:0]data_point,
     
    output [3:0]data_out,  //����洢������
    
    output reg data_in_start_en = 0,         //�������뿪ʼ��־(�˱�־��������)
    output reg data_count_finish = 0,        //ͳ��������ʹ��
    output [8:0]data_num_count_w9,   //����9��Ƶ�� ��ͬ
    output [8:0]data_num_count_w8,
    output [8:0]data_num_count_w7,
    output [8:0]data_num_count_w6,
    output [8:0]data_num_count_w5,
    output [8:0]data_num_count_w4,
    output [8:0]data_num_count_w3,
    output [8:0]data_num_count_w2,
    output [8:0]data_num_count_w1,
    output [8:0]data_num_count_w0

    );
    
    reg [3:0]data_in_r[255:0];      //����һ����RAM�Ļ��ǲ��ǻ��ʡ��Դ�����Ƿ��ʿ��ܻ������ƣ�RAMһ��ֻ�ܷ���һ�����ݣ�
    reg [8:0]data_num_count[9:0];  //������¼9-0ÿ�����ֵ�Ƶ�ȣ�data_num_count[9]��ʾ9��Ƶ�ȣ�data_num_count[0]��ʾ0��Ƶ��)
    reg [8:0]data_in_count = 9'b0000_00000;    //����256�� 
   
    
    assign data_num_count_w9 = (data_in==4'd9)? (data_num_count[9]+1'b1):data_num_count[9];
    assign data_num_count_w8 = (data_in==4'd8)? (data_num_count[8]+1'b1):data_num_count[8];
    assign data_num_count_w7 = (data_in==4'd7)? (data_num_count[7]+1'b1):data_num_count[7];
    assign data_num_count_w6 = (data_in==4'd6)? (data_num_count[6]+1'b1):data_num_count[6];
    assign data_num_count_w5 = (data_in==4'd5)? (data_num_count[5]+1'b1):data_num_count[5];
    assign data_num_count_w4 = (data_in==4'd4)? (data_num_count[4]+1'b1):data_num_count[4];
    assign data_num_count_w3 = (data_in==4'd3)? (data_num_count[3]+1'b1):data_num_count[3];
    assign data_num_count_w2 = (data_in==4'd2)? (data_num_count[2]+1'b1):data_num_count[2];
    assign data_num_count_w1 = (data_in==4'd1)? (data_num_count[1]+1'b1):data_num_count[1];
    assign data_num_count_w0 = (data_in==4'd0)? (data_num_count[0]+1'b1):data_num_count[0];
   
    assign data_out = data_in_r[data_point];
    
    always@(posedge clk)
    begin
    
      if(start == 1 && rst_n == 1) data_in_start_en <= 1;    //start�����ش���data_in_start_en�ź����ߣ���Ϊ�������뿪ʼ��
      else data_in_start_en <= data_in_start_en;  //����д��֤start�ź�����֮��data_in_start_en�ź���Ϊ�ߵ�ƽ״̬
        
      if(rst_n == 0)
        begin
        data_in_count <= 0;       //��λ֮�����������
        data_in_start_en <= 0;     //��λ֮���������뿪ʼ��־����
        data_count_finish <= 0;  // ��λͳ����ϵ������־
        
        data_num_count[9] <= 0;    //Ƶ��ȫ����ʼ��Ϊ0
        data_num_count[8] <= 0;
        data_num_count[7] <= 0;
        data_num_count[6] <= 0;
        data_num_count[5] <= 0;
        data_num_count[4] <= 0;
        data_num_count[3] <= 0;
        data_num_count[2] <= 0;
        data_num_count[1] <= 0;
        data_num_count[0] <= 0;
        end
      else
        begin                                               //������˵����Ӧ��ѡ256 
        if(data_in_start_en == 1 && data_in_count <= 256)   //����д��Ϊ�˱���©����һ�����ݣ���ʱ����濴һ�¾����᲻��©��
          begin
          
              data_count_finish <= 0;  //û��ͳ�����֮ǰ���0  
              data_in_count <= data_in_count + 1;      //��¼�������ݸ���
              
              if(data_in_count > 0)   //Ϊ�˷�ֹ��ǰ��ʼһ��ʱ�Ӵ�����
              begin
                data_in_r[data_in_count - 1] <= data_in;     //����������  ע�������±���[data_in_count - 1]
                case(data_in)
                    4'b0001: begin data_num_count[1] <= data_num_count[1] + 1; end
                    4'b0010: begin data_num_count[2] <= data_num_count[2] + 1; end
                    4'b0011: begin data_num_count[3] <= data_num_count[3] + 1; end
                    4'b0100: begin data_num_count[4] <= data_num_count[4] + 1; end
                    4'b0101: begin data_num_count[5] <= data_num_count[5] + 1; end
                    4'b0110: begin data_num_count[6] <= data_num_count[6] + 1; end
                    4'b0111: begin data_num_count[7] <= data_num_count[7] + 1; end
                    4'b1000: begin data_num_count[8] <= data_num_count[8] + 1; end
                    4'b1001: begin data_num_count[9] <= data_num_count[9] + 1; end
                    default: begin data_num_count[0] <= data_num_count[0] + 1; end  //��ôдΪ�˷�ֹ����������,�����о�д��һ�䲻�Ǻܺ���
                endcase
                if(data_in_count == 256) data_count_finish <= 1; //��ǰһ���������ߣ�Ϊ��Ԥȡ����
              end
            
          end
        else
        begin
            data_count_finish <= data_count_finish;
        end
                    
        end
        
    end
    
endmodule
