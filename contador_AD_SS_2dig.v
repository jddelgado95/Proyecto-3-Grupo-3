`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 12:05:57 AM
// Design Name: 
// Module Name: contador_AD_SS_2dig
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


module contador_AD_SS_2dig
(
input wire clk,
input wire reset,
input wire [3:0] contadoresH,//en_count,
input wire Arriba,//enUP,
input wire Abajo,//enDOWN,
output wire [7:0] datos_SS//data_SS//Dígitos BCD ya concatenados hacia los registros(8 bits)
);

localparam N = 6; // Para definir el número de bits del contador (hasta 59->6 bits)
//Declaración de señales
reg [N-1:0] q_act, q_next;
/*reg enUP_reg, enDOWN_reg;
wire enUP_tick, enDOWN_tick;*/
wire [N-1:0] count_data;
reg [3:0] digit1, digit0;


//Detección de flancos
//always@(posedge clk)
//begin
//enUP_reg <= Arriba;
//enDOWN_reg <= Abajo;
//end
//assign enUP_tick = ~enUP_reg & enUP;
//assign enDOWN_tick = ~enDOWN_reg & enDOWN;*/

//=============================================
// Bits del contador para generar una señal periódica de (2^N)*10ns
localparam N_bits =24;//~4Hz

reg [N_bits-1:0] btn_pulse_reg;
reg btn_pulse;

always @(posedge clk, posedge reset) //ciclo donde cada vez que hay una subida de reloj suma 1 al registro btn_pulse
begin
	if (reset)begin btn_pulse_reg <= 0; btn_pulse <= 0; end 
	
	else
	begin
		if (btn_pulse_reg == 24'd12999999) //cuando llege a 12999999 se reinicia el registro
			begin
			btn_pulse_reg <= 0;
			btn_pulse <= ~btn_pulse;
			end
		else
			btn_pulse_reg <= btn_pulse_reg + 1'b1;
	end
end	
//____________________________________________________________________________________________________________



always@(posedge clk, posedge reset) //cada vez que hay un cambio de bajo a alto de btn_pulse el q_act cambia al estado siguiente
begin	
	
	if(reset)
	begin
		q_act <= 6'b0;
	end
	
	else
	begin
		q_act <= q_next;
	end
end




always@* //ciclo donde cada vez que los contadores habilitados sea 1 va a poder cofigurar los segundos sumando 1 o restando 1 al q_act
begin

	if (contadoresH == 1)
	begin
		if (Arriba)
		begin
			if (q_act >= 6'd59) q_next = 6'd0;
			else q_next = q_act + 6'd1;
		end
		
		else if (Abajo)
		begin
			if (q_act == 6'd0) q_next = 6'd59;
			else q_next = q_act - 6'd1;
		end
		else q_next = q_act;
	end
	else q_next = q_act; //si no el contadoresH no es 1 se mantiene el valor de q_act
	
end

assign count_data = q_act;



always@*  // Se decodifica el count_data a de decimal a binario con 2 digitos
begin
case(count_data)
6'd0: begin digit1 = 4'b0000; digit0 = 4'b0000; end
6'd1: begin digit1 = 4'b0000; digit0 = 4'b0001; end
6'd2: begin digit1 = 4'b0000; digit0 = 4'b0010; end
6'd3: begin digit1 = 4'b0000; digit0 = 4'b0011; end
6'd4: begin digit1 = 4'b0000; digit0 = 4'b0100; end
6'd5: begin digit1 = 4'b0000; digit0 = 4'b0101; end
6'd6: begin digit1 = 4'b0000; digit0 = 4'b0110; end
6'd7: begin digit1 = 4'b0000; digit0 = 4'b0111; end
6'd8: begin digit1 = 4'b0000; digit0 = 4'b1000; end
6'd9: begin digit1 = 4'b0000; digit0 = 4'b1001; end

6'd10: begin digit1 = 4'b0001; digit0 = 4'b0000; end
6'd11: begin digit1 = 4'b0001; digit0 = 4'b0001; end
6'd12: begin digit1 = 4'b0001; digit0 = 4'b0010; end
6'd13: begin digit1 = 4'b0001; digit0 = 4'b0011; end
6'd14: begin digit1 = 4'b0001; digit0 = 4'b0100; end
6'd15: begin digit1 = 4'b0001; digit0 = 4'b0101; end
6'd16: begin digit1 = 4'b0001; digit0 = 4'b0110; end
6'd17: begin digit1 = 4'b0001; digit0 = 4'b0111; end
6'd18: begin digit1 = 4'b0001; digit0 = 4'b1000; end
6'd19: begin digit1 = 4'b0001; digit0 = 4'b1001; end

6'd20: begin digit1 = 4'b0010; digit0 = 4'b0000; end
6'd21: begin digit1 = 4'b0010; digit0 = 4'b0001; end
6'd22: begin digit1 = 4'b0010; digit0 = 4'b0010; end
6'd23: begin digit1 = 4'b0010; digit0 = 4'b0011; end
6'd24: begin digit1 = 4'b0010; digit0 = 4'b0100; end
6'd25: begin digit1 = 4'b0010; digit0 = 4'b0101; end
6'd26: begin digit1 = 4'b0010; digit0 = 4'b0110; end
6'd27: begin digit1 = 4'b0010; digit0 = 4'b0111; end
6'd28: begin digit1 = 4'b0010; digit0 = 4'b1000; end
6'd29: begin digit1 = 4'b0010; digit0 = 4'b1001; end

6'd30: begin digit1 = 4'b0011; digit0 = 4'b0000; end
6'd31: begin digit1 = 4'b0011; digit0 = 4'b0001; end
6'd32: begin digit1 = 4'b0011; digit0 = 4'b0010; end
6'd33: begin digit1 = 4'b0011; digit0 = 4'b0011; end
6'd34: begin digit1 = 4'b0011; digit0 = 4'b0100; end
6'd35: begin digit1 = 4'b0011; digit0 = 4'b0101; end
6'd36: begin digit1 = 4'b0011; digit0 = 4'b0110; end
6'd37: begin digit1 = 4'b0011; digit0 = 4'b0111; end
6'd38: begin digit1 = 4'b0011; digit0 = 4'b1000; end
6'd39: begin digit1 = 4'b0011; digit0 = 4'b1001; end

6'd40: begin digit1 = 4'b0100; digit0 = 4'b0000; end
6'd41: begin digit1 = 4'b0100; digit0 = 4'b0001; end
6'd42: begin digit1 = 4'b0100; digit0 = 4'b0010; end
6'd43: begin digit1 = 4'b0100; digit0 = 4'b0011; end
6'd44: begin digit1 = 4'b0100; digit0 = 4'b0100; end
6'd45: begin digit1 = 4'b0100; digit0 = 4'b0101; end
6'd46: begin digit1 = 4'b0100; digit0 = 4'b0110; end
6'd47: begin digit1 = 4'b0100; digit0 = 4'b0111; end
6'd48: begin digit1 = 4'b0100; digit0 = 4'b1000; end
6'd49: begin digit1 = 4'b0100; digit0 = 4'b1001; end

6'd50: begin digit1 = 4'b0101; digit0 = 4'b0000; end
6'd51: begin digit1 = 4'b0101; digit0 = 4'b0001; end
6'd52: begin digit1 = 4'b0101; digit0 = 4'b0010; end
6'd53: begin digit1 = 4'b0101; digit0 = 4'b0011; end
6'd54: begin digit1 = 4'b0101; digit0 = 4'b0100; end
6'd55: begin digit1 = 4'b0101; digit0 = 4'b0101; end
6'd56: begin digit1 = 4'b0101; digit0 = 4'b0110; end
6'd57: begin digit1 = 4'b0101; digit0 = 4'b0111; end
6'd58: begin digit1 = 4'b0101; digit0 = 4'b1000; end
6'd59: begin digit1 = 4'b0101; digit0 = 4'b1001; end

default:  begin digit1 = 0; digit0 = 0; end
endcase
end

assign datos_SS = {digit1,digit0};
endmodule
