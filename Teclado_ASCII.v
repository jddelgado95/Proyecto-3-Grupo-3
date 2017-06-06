`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2017 03:26:52 PM
// Design Name: 
// Module Name: Teclado_ASCII
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


module Teclado_ASCII(
    
    input wire [7:0] key_code,
    output reg [7:0] ascii_code
);

always@*//ciclo en el que se pasa del codigo de la tecla al codigo ascii de la misma para que sea manejada por el microcontrolador 
begin

	case(key_code)
		8'h05: ascii_code = 8'h21;//F1(!) Reset del rtc
		8'h06: ascii_code = 8'h22;//F2(")
		8'h1c: ascii_code = 8'h41;//A Salida de configuracion sin configurar
		8'h23: ascii_code = 8'h44;//D Apagar alarma del timer
		8'h2b: ascii_code = 8'h46;//F entrar en configuracion fecha
		8'h33: ascii_code = 8'h48;//H entra en configuracion hora
		8'h3a: ascii_code = 8'h4d;//M
		8'h2d: ascii_code = 8'h52;//R 
		8'h1b: ascii_code = 8'h53;//S cambiar formato hora
		8'h2c: ascii_code = 8'h54;//T entra en configuracion timer
		8'h72: ascii_code = 8'h35;//flecha abajo (5) 
		8'h6b: ascii_code = 8'h34;//flecha izquierda (4) 
		8'h74: ascii_code = 8'h36;//flecha derecha (6)
		8'h75: ascii_code = 8'h38;//flecha arriba (8)
		8'h5a: ascii_code = 8'h0d;//Enter
		default ascii_code = 8'b0;//NULL char
	endcase
end
endmodule
