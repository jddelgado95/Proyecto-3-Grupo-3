`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 01:01:01 PM
// Design Name: 
// Module Name: Mcontrolador
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


module Mcontrolador(

    input wire clk, reset,
    input wire interrupt,
    input wire [7:0] in_port,//entrada de datos/direcciones del microcontrolador 
    output wire write_strobe, k_write_strobe, read_strobe,
    output wire	interrupt_ack,
    output wire	[7:0] port_id,//salida de direcciones de control de perifericos del proyecto
    output wire	[7:0] out_port //salida de datos y direcciones del microcontrolador
);

//Conexiones entre la memoria de programa y el kcpsm6
    wire [11:0]	address;
    wire [17:0]	instruction;
    wire bram_enable;
    wire kcpsm6_sleep;         
    wire kcpsm6_reset;         
    wire rdl;

    assign kcpsm6_reset = reset | rdl; //OR entre el reset del proyecto y rdl de la ROM
    assign kcpsm6_sleep = 1'b0;

    //Instanciaciones del procesador y la memoria de programa
     kcpsm6 #(//instancia del archivo KCPSM6 descargado de la pagina de Xilinx 
        .interrupt_vector	(12'h3FF),
        .scratch_pad_memory_size(64),
        .hwbuild		(8'h00))
        KCPSM6_instancia(//instancia_processor
        .address 		(address),
        .instruction 	(instruction),
        .bram_enable 	(bram_enable),
        .port_id 		(port_id),
        .write_strobe 	(write_strobe),
        .k_write_strobe 	(k_write_strobe),
        .out_port 		(out_port),
        .read_strobe 	(read_strobe),
        .in_port 		(in_port),
        .interrupt 		(interrupt),
        .interrupt_ack 	(interrupt_ack),
        .reset 		(kcpsm6_reset),
        .sleep		(kcpsm6_sleep),
        .clk 			(clk)
    );

    ROM_Programa #( //instancia de la ROM del programa que contiene las instrucciones del proyecto
        .C_FAMILY		   ("7S"),   	//Family 'S6' or 'V6'
        .C_RAM_SIZE_KWORDS	(2),  	//Program size '1', '2' or '4'
        .C_JTAG_LOADER_ENABLE	(0))  	//Include JTAG Loader when set to '1' 
        instancia_ROM_Programa (    				//Name to match your PSM file
        .rdl 			(rdl),
        .enable 		(bram_enable),
        .address 		(address),
        .instruction 	(instruction),
        .clk 			(clk)
    );

endmodule
