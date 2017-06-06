`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2017 03:30:05 PM
// Design Name: 
// Module Name: Receptor_tecla
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


module Receptor_tecla(
    
    input wire clk, reset,
    input wire ps2data, ps2clk, rx_en,
    output reg rx_done_tick,
    output wire [10:0] dout
);

// Declaración simbólica de estados
localparam [1:0]
	idle = 2'b00,
	dps  = 2'b01,
	load = 2'b10;

// Declaración de señales
reg [1:0] state_reg, state_next;
reg [7:0] filter_reg;
wire [7:0] filter_next;
reg f_ps2clk_reg;
wire f_ps2clk_next;
reg [3:0] n_reg, n_next;//Contador auxiliar para manejar el número de bits ensamblados
reg [10:0] assembled_data_reg, assembled_data_next; //Buffer para guardar el dato
wire fall_edge;

//======================================================
// Filtrado y detección del flanco negativo de ps2_clk
//======================================================
always @(posedge clk, posedge reset)//ciclo para actualizar los estados de la deteccion de flanco negativo
if (reset)
	begin
		filter_reg <= 0;
		f_ps2clk_reg <= 0;
	end
else
	begin
		filter_reg <= filter_next;
		f_ps2clk_reg <= f_ps2clk_next;
	end

assign filter_next = {ps2clk, filter_reg[7:1]};
assign f_ps2clk_next = (filter_reg==8'b11111111) ? 1'b1 :
							(filter_reg==8'b00000000) ? 1'b0 :
							 f_ps2clk_reg;
assign fall_edge = f_ps2clk_reg & ~f_ps2clk_next;//Detección del flanco negativo del clk del teclado

//=================================================
// FSMD
//=================================================
// Estado FSMD y registros de datos
always @(posedge clk, posedge reset)//ciclo que actuliza los estados de la FSMD
	if (reset)
		begin
			state_reg <= idle;
			n_reg <= 0;
			assembled_data_reg <= 0;
		end
	else
		begin
			state_reg <= state_next;
			n_reg <= n_next;
			assembled_data_reg <= assembled_data_next;
		end
// Lógica de siguiente estado de la FSMD
always @*
begin
	state_next = state_reg;
	rx_done_tick = 1'b0;
	n_next = n_reg;
	assembled_data_next = assembled_data_reg;
	case (state_reg)
		idle:
			if (fall_edge & rx_en)//cuando se cumplen estas 2 condiciones puede emsanblar el primer bit que seria el de inicio
				begin
					// shift al bit entrante
					assembled_data_next = {ps2data, assembled_data_reg[10:1]};
					n_next = 4'b1001;
					state_next = dps;//pasa al siguiente estado
				end
		dps: //Ensamblar 8 bits de datos + 1 paridad + 1 parada
			if (fall_edge)
				begin
					assembled_data_next = {ps2data, assembled_data_reg[10:1]};
					if (n_reg==0)
						state_next = load;
					else
						n_next = n_reg - 1'b1;
				end
		load: // Ciclo de reloj extra para terminar el ensamblaje del dato del teclado
			begin
				state_next = idle;
				rx_done_tick = 1'b1;
			end
	endcase
end
// Salida
assign dout = assembled_data_reg[10:0]; // bits de datos (se incluyen bit de inicio, paridad y parada)
//Nota: Bits del código de la teclado [8:1]

endmodule
