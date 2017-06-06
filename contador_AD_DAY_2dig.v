`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 09:40:02 AM
// Design Name: 
// Module Name: contador_AD_DAY_2dig
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


module contador_AD_DAY_2dig
(
input wire clk,
input wire reset,
input wire [3:0] contadoresH,//en_count,
input wire Arriba,//enUP,
input wire Abajo,//enDOWN,
output wire [7:0] datos_Dia//data_DAY
);

localparam N = 5; // Para definir el número de bits del contador (hasta 31->5 bits)
//Declaración de señales
reg [N-1:0] q_act, q_next;
wire [N-1:0] count_data;
reg [3:0] digit1, digit0;

// Bits del contador para generar una señal periódica de (2^N)*10ns
localparam N_bits =24;//~4Hz

reg [N_bits-1:0] btn_pulse_reg;
reg btn_pulse;

always @(posedge clk, posedge reset) //ciclo donde cada vez que hay una subida de reloj suma 1 al registro btn_pulse
begin
	if (reset)
	   begin btn_pulse_reg <= 0; btn_pulse <= 0; 
	   end
	
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

//Descripción del comportamiento
always@(posedge clk, posedge reset) //cada vez que hay un cambio de bajo a alto de btn_pulse el q_act cambia al estado siguiente
begin	
	
	if(reset)
	begin
		q_act <= 5'b0;
	end
	
	else
	begin
		q_act <= q_next;
	end
end


//Lógica de salida
always@* //ciclo donde cada vez que los contadores habilitados sea 6 va a poder cofigurar el dia sumando 1 o restando 1 al q_act
begin

	if (contadoresH == 6)
	begin
		if (Arriba)
		begin
			if (q_act >= 5'd30) q_next = 5'd0;
			else q_next = q_act + 5'd1;
		end
		
		else if (Abajo)
		begin
			if (q_act == 5'd0) q_next = 5'd30;
			else q_next = q_act - 5'd1;
		end
		else q_next = q_act;
	end
	else q_next = q_act; //si no el contadoresH no es 6 se mantiene el valor de q_act
	
end

assign count_data = q_act + 5'b1;//Suma 1 a todas las cuentas de 0->30 a 1->31



always@* // Se decodifica el count_data a de decimal a binario con 2 digitos
begin
case(count_data)

5'd1: begin digit1 = 4'b0000; digit0 = 4'b0001; end
5'd2: begin digit1 = 4'b0000; digit0 = 4'b0010; end
5'd3: begin digit1 = 4'b0000; digit0 = 4'b0011; end
5'd4: begin digit1 = 4'b0000; digit0 = 4'b0100; end
5'd5: begin digit1 = 4'b0000; digit0 = 4'b0101; end
5'd6: begin digit1 = 4'b0000; digit0 = 4'b0110; end
5'd7: begin digit1 = 4'b0000; digit0 = 4'b0111; end
5'd8: begin digit1 = 4'b0000; digit0 = 4'b1000; end
5'd9: begin digit1 = 4'b0000; digit0 = 4'b1001; end

5'd10: begin digit1 = 4'b0001; digit0 = 4'b0000; end
5'd11: begin digit1 = 4'b0001; digit0 = 4'b0001; end
5'd12: begin digit1 = 4'b0001; digit0 = 4'b0010; end
5'd13: begin digit1 = 4'b0001; digit0 = 4'b0011; end
5'd14: begin digit1 = 4'b0001; digit0 = 4'b0100; end
5'd15: begin digit1 = 4'b0001; digit0 = 4'b0101; end
5'd16: begin digit1 = 4'b0001; digit0 = 4'b0110; end
5'd17: begin digit1 = 4'b0001; digit0 = 4'b0111; end
5'd18: begin digit1 = 4'b0001; digit0 = 4'b1000; end
5'd19: begin digit1 = 4'b0001; digit0 = 4'b1001; end

5'd20: begin digit1 = 4'b0010; digit0 = 4'b0000; end
5'd21: begin digit1 = 4'b0010; digit0 = 4'b0001; end
5'd22: begin digit1 = 4'b0010; digit0 = 4'b0010; end
5'd23: begin digit1 = 4'b0010; digit0 = 4'b0011; end
5'd24: begin digit1 = 4'b0010; digit0 = 4'b0100; end
5'd25: begin digit1 = 4'b0010; digit0 = 4'b0101; end
5'd26: begin digit1 = 4'b0010; digit0 = 4'b0110; end
5'd27: begin digit1 = 4'b0010; digit0 = 4'b0111; end
5'd28: begin digit1 = 4'b0010; digit0 = 4'b1000; end
5'd29: begin digit1 = 4'b0010; digit0 = 4'b1001; end

5'd30: begin digit1 = 4'b0011; digit0 = 4'b0000; end
5'd31: begin digit1 = 4'b0011; digit0 = 4'b0001; end

default:  begin digit1 = 0; digit0 = 0; end
endcase
end

assign datos_Dia = {digit1,digit0};

endmodule
