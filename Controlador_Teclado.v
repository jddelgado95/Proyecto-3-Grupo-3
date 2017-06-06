`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2017 03:30:52 PM
// Design Name: 
// Module Name: Controlador_Teclado
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


module Controlador_Teclado(

input wire clk, reset,
input wire ps2data, ps2clk,
input wire [7:0] port_id,
input wire read_strobe,
output wire [7:0] ascii_code
);

//Declaración de señales de conexión
wire [10:0] dout;
wire rx_done_tick;
wire gotten_code_flag;
wire [7:0] key_code;
reg [7:0] key_code_reg, key_code_next;

//Para la máquina de estados del registro de la tecla
reg [1:0] state_current, state_next;

localparam [1:0] hold_key_code = 2'b0, read_key_code = 2'b01, reset_key_code = 2'b10;

// instancia de los 3 modulos que componen el controlador de teclado
Receptor_tecla instancia_receptor_teclado_ps2   
(
.clk(clk),
.reset(reset),
.ps2data(ps2data),
.ps2clk(ps2clk),
.rx_en(1'b1),
.rx_done_tick(rx_done_tick),
.dout(dout)
);

Reconocimiento_tecla instancia_identificador_teclas
(
.clk(clk),
.reset(reset),
.rx_done_tick(rx_done_tick),
.dout(dout[8:1]),//Utilizar solo los bits que realmente contienen el código de la tecla [8:1]
.gotten_code_flag(gotten_code_flag) //Bandera para actualizar el FIFO
);

Teclado_ASCII instancia_keycode_to_ascii
(
.key_code(key_code),
.ascii_code(ascii_code)
);

//===================================================
// Registro para conservar la última tecla presionada
//===================================================
//Secuencial
always@(posedge clk)
begin
	if(reset) begin
		key_code_reg <= 8'b0;
		state_current <= hold_key_code;
	end
	else begin
		key_code_reg <= key_code_next;
		state_current <= state_next;
	end
end
//Lógica de estado siguiente
always@*
	begin
		case(state_current)
			hold_key_code://Hold
			begin
			key_code_next = key_code_reg;
				if(gotten_code_flag) state_next = read_key_code;//si code flag es igual a 1 puede pasar al estado de leer el codigo de la tecla
				else state_next = state_current;
			end
			
			read_key_code://Escribe registro/Espera lectura del micro
			begin	
			key_code_next = dout[8:1]; //Utilizar solo los bits que realmente contienen el código de la tecla
				if(port_id == 8'h02 && read_strobe == 1) state_next = reset_key_code;//si estas 2 condiciones se cumplen pasa al estado de resetear el codigo de la tecla
				else state_next = state_current;
			end
			reset_key_code:
			begin
			key_code_next = 8'b0;//pone el codigo de la tecla en 0
				state_next = hold_key_code;
			end
			default:
			begin
				key_code_next = key_code_reg;
				state_next = state_current;
			end
		endcase
	end
assign key_code = key_code_reg;

endmodule
