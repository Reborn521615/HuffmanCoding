`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/05 17:17:40
// Design Name: 
// Module Name: data_out
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

module data_out(
    input clk,
    input rst_n,
    input encoding_finish,   //������ɱ�־
    input [3:0]data_in,   //�������������
    
    input  [8:0]code_mask_0,    //���ݱ��볤��
    input  [8:0]code_mask_1,
    input  [8:0]code_mask_2,
    input  [8:0]code_mask_3,
    input  [8:0]code_mask_4,
    input  [8:0]code_mask_5,
    input  [8:0]code_mask_6,
    input  [8:0]code_mask_7,
    input  [8:0]code_mask_8,
    input  [8:0]code_mask_9,
    input  [8:0]code_0,           //���ݱ��� 
    input  [8:0]code_1,   
    input  [8:0]code_2,    
    input  [8:0]code_3,    
    input  [8:0]code_4,    
    input  [8:0]code_5,     
    input  [8:0]code_6,      
    input  [8:0]code_7,     
    input  [8:0]code_8,   
    input  [8:0]code_9,    
    
    output reg huffman_out_finish = 0,
    output reg[8:0] data_point = 9'b000000000,  //�洢������ָ��
    output output_data,   //�������
    output reg output_gap,    //������ֲ�ͬ��������
    output output_done,   //�����ɱ�־
    output output_start,   //�����ʼ��־
    
    output code_en,  //�������ʹ��λ
    output [3:0] data_select   //�������ѡ���������ĸ�
    );
    
    reg [3:0]huffman_state = 4'b0000;   //�洢���������0~9��
    
    reg [8:0] out_code_buff=9'd0;    //���뻺����
    reg [8:0] out_mask_buff=9'd0;    //���뻺����
    reg [8:0] code_select=9'd0;
    reg [8:0] mask_select=9'd0;
    
    reg output_started=0;
    reg output_finished=0;
    assign output_start = encoding_finish && (~output_started);
    assign output_done = (data_point == 257)? 1'b1 : 1'b0;  //ע�⣡�������������������������ܶ�˲�����ߵı�־�źŶ�������ôд
    assign output_data = out_code_buff[8];  //����ź�Ϊ���뻺���������λ
    assign code_en = out_mask_buff[7];      //ȡ��2λ
    assign data_select = (huffman_out_finish == 1'b1)? data_in : huffman_state;     //ѡ�����0~9����0~255
    
always@ (data_select or encoding_finish or clk)    //������е�ƽ��ʱ��Ҫ��
begin
    case(data_select)
        4'd0: mask_select<=code_mask_0;
        4'd1: mask_select<=code_mask_1;
        4'd2: mask_select<=code_mask_2;
        4'd3: mask_select<=code_mask_3;
        4'd4: mask_select<=code_mask_4;
        4'd5: mask_select<=code_mask_5;
        4'd6: mask_select<=code_mask_6;
        4'd7: mask_select<=code_mask_7;
        4'd8: mask_select<=code_mask_8;
        default : mask_select<=code_mask_9;
    endcase
end

always@ (data_select or encoding_finish or clk)    //������е�ƽ��ʱ��Ҫ��
begin
    case(data_select)
        4'd0: code_select<=code_0;
        4'd1: code_select<=code_1;
        4'd2: code_select<=code_2;
        4'd3: code_select<=code_3;
        4'd4: code_select<=code_4;
        4'd5: code_select<=code_5;
        4'd6: code_select<=code_6;
        4'd7: code_select<=code_7;
        4'd8: code_select<=code_8;
        default : code_select<=code_9;
    endcase
end

always@ (posedge clk)
begin
    if(rst_n == 0)
    begin
        huffman_state <= 0;
        output_gap <= 0;
        //output_start <= 0;
        huffman_out_finish <= 0;
        data_point <= 0;
        
        out_code_buff<=0;
        out_mask_buff<=0;
        output_started<=0;
        output_finished<=0;
    end
    else if(encoding_finish == 1 && huffman_out_finish ==0)   //�����Ѿ����������0~9����
    begin
        if(code_en==1'b1)
        begin
            out_code_buff <= {out_code_buff[7:0],1'b0};
            out_mask_buff <= {out_mask_buff[7:0],1'b0};
            output_gap<=1'b0;
            output_started<=1'b1;
        end
        else
        begin
            out_code_buff <= code_select;
            out_mask_buff <= mask_select;
            output_gap <= 1'b1;
            
            if(output_started==0) begin
                output_started<=1'b1;
                //output_start<=1'b0;
            end
            
            if(huffman_state>=4'd9) huffman_out_finish <= 1'b1;
            else huffman_state <= huffman_state+1'b1;
            
        end
    end
    else if(huffman_out_finish == 1 && output_finished==0)  //���0~9�����������ʼ���0~255
    begin
        if(code_en==1'b1)   //������Ҫ�����һ������9�ı���
        begin
            out_code_buff <= {out_code_buff[7:0],1'b0};
            out_mask_buff <= {out_mask_buff[7:0],1'b0};
            //output_gap<=1'b1;
        end
        else
        begin
            out_code_buff <= code_select;
            out_mask_buff <= mask_select;
            //output_gap<=1'b1;
            if(data_point>=9'd256) begin
                output_finished <= 1'b1;
                data_point<=9'd257; //��ʱ��output_done����
            end
            else data_point <= data_point+1'b1;
            
        end
        
        if(data_point>0)
        begin
            output_gap<=1'b1;
        end
        else if(data_point==0&&code_en!=1'b1)
        begin
            output_gap<=1'b1;
        end
        else
        begin
            output_gap<=1'b0;
        end
    end
    else data_point<=9'd0;
end
  
endmodule