`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/01 10:42:20
// Design Name: 
// Module Name: HuffmanCoding
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


module HuffmanCoding(
    input wire clk,
    input wire rst_n,
    input wire [3:0] data_in,
    input wire start,
    
//    output [8:0]code_mask_0,
//    output [8:0]code_mask_1,
//    output [8:0]code_mask_2,
//    output [8:0]code_mask_3,
//    output [8:0]code_mask_4,
//    output [8:0]code_mask_5,
//    output [8:0]code_mask_6,
//    output [8:0]code_mask_7,
//    output [8:0]code_mask_8,
//    output [8:0]code_mask_9,
    output [8:0]code_0,
    output [8:0]code_1,
    output [8:0]code_2,
    output [8:0]code_3,
    output [8:0]code_4,
    output [8:0]code_5,
    output [8:0]code_6,
    output [8:0]code_7,
    output [8:0]code_8,
    output [8:0]code_9,
    
//    output [4:0]new_root_index,
    output [4:0]min1,
    output [4:0]min2,
//    output  [3:0] min1_num_index,
//    output  [3:0] min2_num_index,
//    output [9:0] min1_mask,
//    output [9:0] min2_mask,

    output encoding_finish,
    output huffman_out_finish,
//    output [3:0]data_out,

//    output [8:0]data_num_count_w0,
//    output [8:0]data_num_count_w1,
//    output [8:0]data_num_count_w2,
//    output [8:0]data_num_count_w3,
//    output [8:0]data_num_count_w4,
//    output [8:0]data_num_count_w5,
//    output [8:0]data_num_count_w6,
//    output [8:0]data_num_count_w7,
//    output [8:0]data_num_count_w8,
//    output [8:0]data_num_count_w9,
    output data_count_finish,
    
//    output [8:0]nummem_0,
//    output [8:0]nummem_1,
//    output [8:0]nummem_2,
//    output [8:0]nummem_3,
//    output [8:0]nummem_4,
//    output [8:0]nummem_5,
//    output [8:0]nummem_6,
//    output [8:0]nummem_7,
//    output [8:0]nummem_8,
//    output [8:0]nummem_9,
//    output [8:0]data_point,
    output wire output_data,   
    output wire output_start,  
    output wire output_done,   
    output wire output_gap,     //������ֲ�ͬ��������
    
    output code_en,
    output [3:0] data_select   //�������ѡ���������ĸ�
    );
    
    wire data_out_start;
    //wire data_count_finish_temp;
//    wire [3:0]data_out;
//    wire data_count_finish;
    wire [8:0]data_num_count_w0;
    wire [8:0]data_num_count_w1;
    wire [8:0]data_num_count_w2;
    wire [8:0]data_num_count_w3;
    wire [8:0]data_num_count_w4;
    wire [8:0]data_num_count_w5;
    wire [8:0]data_num_count_w6;
    wire [8:0]data_num_count_w7;
    wire [8:0]data_num_count_w8;
    wire [8:0]data_num_count_w9;
    
    wire [4:0]new_root_index;
    wire [4:0]min1;
    wire [4:0]min2;
    wire [8:0]data_point;
    wire [3:0]data_out;
    
    wire  [3:0] min1_num_index;
    wire  [3:0] min2_num_index;
    wire [9:0] min1_mask;
    wire [9:0] min2_mask;
    
    wire [8:0]code_mask_0;
    wire [8:0]code_mask_1;
    wire [8:0]code_mask_2;
    wire [8:0]code_mask_3;
    wire [8:0]code_mask_4;
    wire [8:0]code_mask_5;
    wire [8:0]code_mask_6;
    wire [8:0]code_mask_7;
    wire [8:0]code_mask_8;
    wire [8:0]code_mask_9;
    
    
    wire encoding_finish;

//  clk_wiz_0 clk_wiz_0_1
//   (
//    .clk_in1(clk),      // input clk_in1   100MHZ
//    .clk(clk)     // output clk  800MHZ
//        );   

    data_store data_store_1(
        .clk(clk),    //��������ʱ��
        .rst_n(rst_n),  //��λ�ź�
        .start(start),  //��ʼ����ı�־�ź�
        .data_in(data_in), //�������� 4bit
        .data_out_start(data_out_start),  //��ʼ����洢�����ݵı�־
        .data_point(data_point),
         
        .data_out(data_out),  //����洢������ 4bit        
        .data_in_start_en(data_in_start_en),
        .data_count_finish(data_count_finish),        //ͳ��������ʹ��
        .data_num_count_w9(data_num_count_w9),   //����9��Ƶ�� ��ͬ 9bit
        .data_num_count_w8(data_num_count_w8),
        .data_num_count_w7(data_num_count_w7),
        .data_num_count_w6(data_num_count_w6),
        .data_num_count_w5(data_num_count_w5),
        .data_num_count_w4(data_num_count_w4),
        .data_num_count_w3(data_num_count_w3),
        .data_num_count_w2(data_num_count_w2),
        .data_num_count_w1(data_num_count_w1),
        .data_num_count_w0(data_num_count_w0)
        );
    
    select_2min select_2min_1(
        .clk(clk),
        .rst_n(rst_n),
        .data_count_finish(data_count_finish),
        .data_in_start_en(data_in_start_en),
            
        .data_num_count_w9(data_num_count_w9),   //����9��Ƶ�� ��ͬ 9bit
        .data_num_count_w8(data_num_count_w8),
        .data_num_count_w7(data_num_count_w7),
        .data_num_count_w6(data_num_count_w6),
        .data_num_count_w5(data_num_count_w5),
        .data_num_count_w4(data_num_count_w4),
        .data_num_count_w3(data_num_count_w3),
        .data_num_count_w2(data_num_count_w2),
        .data_num_count_w1(data_num_count_w1),
        .data_num_count_w0(data_num_count_w0),
        
//        .nummem_0(nummem_0),
//        .nummem_1(nummem_1),
//        .nummem_2(nummem_2),
//        .nummem_3(nummem_3),
//        .nummem_4(nummem_4),
//        .nummem_5(nummem_5),
//        .nummem_6(nummem_6),
//        .nummem_7(nummem_7),
//        .nummem_8(nummem_8),
//        .nummem_9(nummem_9),
                 
        .new_root_index(new_root_index), //����֦�ڵ�����  5bit
        .min1_num_index(min1_num_index),
        .min2_num_index(min2_num_index),
        .min1_mask(min1_mask),
        .min2_mask(min2_mask),
        .min1(min1),          //5bit
        .min2(min2)           //5bit
        
        );
        
    encoding encoding_1(
        .clk(clk),
        .rst_n(rst_n),
        .data_count_finish(data_count_finish),
        .min1(min1),     //5bit
        .min2(min2),     //5bit
          
        .new_root_index(new_root_index),   //��־���������ɸ���λ��   5bit  
          
        .encoding_finish(encoding_finish),
        .code_mask_0(code_mask_0),    //���ݱ��볤��  4bit
        .code_mask_1(code_mask_1),
        .code_mask_2(code_mask_2),
        .code_mask_3(code_mask_3),
        .code_mask_4(code_mask_4),
        .code_mask_5(code_mask_5),
        .code_mask_6(code_mask_6),
        .code_mask_7(code_mask_7),
        .code_mask_8(code_mask_8),
        .code_mask_9(code_mask_9),
        .code_0(code_0),           //���ݱ���   9bit
        .code_1(code_1),   
        .code_2(code_2),    
        .code_3(code_3),    
        .code_4(code_4),    
        .code_5(code_5),     
        .code_6(code_6),      
        .code_7(code_7),     
        .code_8(code_8),   
        .code_9(code_9)             
        );

    data_out data_out_1(
        .clk(clk),
        .rst_n(rst_n),
        .encoding_finish(encoding_finish),   //������ɱ�־
        .huffman_out_finish(huffman_out_finish),
        .data_in(data_out),   //�������������   4bit   !!!!!!!!!!!!ǧ��ע��������data_out������data_in����������������������������������
            
        .code_mask_0(code_mask_0),    //���ݱ��볤��  4bit
        .code_mask_1(code_mask_1),
        .code_mask_2(code_mask_2),
        .code_mask_3(code_mask_3),
        .code_mask_4(code_mask_4),
        .code_mask_5(code_mask_5),
        .code_mask_6(code_mask_6),
        .code_mask_7(code_mask_7),
        .code_mask_8(code_mask_8),
        .code_mask_9(code_mask_9),
        .code_0(code_0),           //���ݱ��� 9bit
        .code_1(code_1),   
        .code_2(code_2),    
        .code_3(code_3),    
        .code_4(code_4),    
        .code_5(code_5),     
        .code_6(code_6),      
        .code_7(code_7),     
        .code_8(code_8),   
        .code_9(code_9),    
            
        .data_point(data_point),  //�洢������ָ��
        .output_data(output_data),   //�������
        .output_done(output_done),
        .output_gap(output_gap),    //������ֲ�ͬ��������
        .output_start(output_start),   //�����ʼ��־
        
        .code_en(code_en),
        .data_select(data_select)
        );
endmodule
