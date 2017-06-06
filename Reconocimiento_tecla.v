`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2017 03:28:30 PM
// Design Name: 
// Module Name: Reconocimiento_tecla
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


module Reconocimiento_tecla(
input wire clk, reset,
input wire rx_done_tick,//badera que recibe del receptor de teclado
input wire [7:0] dout,//Utilizar solo los bits que realmente contienen el código de la tecla
output reg gotten_code_flag //bandera que le inidca a la maquina de estados en el controlador de teclado que puede abtener el codigo de la tecla
);

//Declaración de constantes
localparam break_code = 8'hF0;

//Declaración simbólica de estados
localparam wait_break_code = 1'b0;
localparam get_code = 1'b1;

//Declaración de señales
reg state_next, state_reg;

//=================================================
// FSM
//=================================================

// Estado FSM y registros de datos

always @(posedge clk, posedge reset)
	if (reset)
		state_reg <= wait_break_code;
	else
		state_reg <= state_next;
		
// Lógica de siguiente estado siguiente de la FSM
always @*
begin
	gotten_code_flag = 1'b0;
	state_next = state_reg;
	case (state_reg)
		wait_break_code:  // Espera "break code"
			if (rx_done_tick == 1'b1 && dout == break_code)//cuando estas 2 condiciones se cumplen pasa al estado de obtener el codigo de la tecla 
				state_next = get_code;
		get_code:  // Obtener el próximo código
			if (rx_done_tick)
				begin
					gotten_code_flag =1'b1;//bandera que indica que se puede obtener el codigo de la tecla
					state_next = wait_break_code;//pasa al estado de esperar tecla de nuevo
				end
	endcase
end
endmodule
