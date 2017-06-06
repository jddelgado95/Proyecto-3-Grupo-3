`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 10:07:39 AM
// Design Name: 
// Module Name: Registro_Universal
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


module Registro_Universal
#(parameter N = 8) //Número de bits y código de decodificado para habilitar el registro
(
	input wire hold,
	input wire [N-1:0]in_rtc_dato,
	input wire [N-1:0]in_count_dato,
	input wire clk, //system clock
	input wire reset, //system reset
	input wire chip_select, //Control data
	output wire [N-1:0]out_dato
);
reg [N-1:0]reg_dato,in_rtc_datoD, in_count_datoD, resultadoH;
reg [N-1:0]next_dato;
wire [7:0] resultado;

//Secuencial
always@(negedge clk, posedge reset)
begin
	if(reset) reg_dato <= 0;
	else reg_dato <= next_dato;
end


//Combinacional
always@*
	begin
	if (~hold) begin
	case(chip_select)
	1'b0: next_dato = in_rtc_dato;
	1'b1: next_dato = in_count_dato;
	endcase
	end
	else next_dato = reg_dato;
	end

assign out_dato = reg_dato;

endmodule
