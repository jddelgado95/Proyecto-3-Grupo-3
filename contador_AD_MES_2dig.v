`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 09:34:23 AM
// Design Name: 
// Module Name: contador_AD_MES_2dig
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


module contador_AD_MES_2dig(
input wire clk,
input wire reset,
input wire [3:0] contadoresH,//en_count,
input wire Arriba,//enUP,
input wire Abajo,//enDOWN,
output wire [7:0] datos_mes//data_MES
);

localparam N = 4; // Para definir el número de bits del contador (hasta 12->4 bits)
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

//Descripción del comportamiento
always@(posedge clk, posedge reset) //cada vez que hay un cambio de bajo a alto de btn_pulse el q_act cambia al estado siguiente
begin	
	
	if(reset)
	begin
		q_act <= 4'b0;
	end
	
	else
	begin
		q_act <= q_next;
	end
end


//Lógica de salida

always@*
begin

	if (contadoresH == 5) //ciclo donde cada vez que los contadores habilitados sea 5 va a poder cofigurar el mes sumando 1 o restando 1 al q_act
	begin
		if (Arriba)
		begin
			if (q_act >= 4'd11) q_next = 4'd0;
			else q_next = q_act + 4'd1;
		end
		
		else if (Abajo)
		begin
			if (q_act == 4'd0) q_next = 4'd11;
			else q_next = q_act - 4'd1;
		end
		else q_next = q_act; //si no el contadoresH no es 5 se mantiene el valor de q_act
	end
	else q_next = q_act;
	
end

assign count_data = q_act + 1'b1;//Suma 1 a todas las cuentas de 0->11 a 1->12



always@* // Se decodifica el count_data a de decimal a binario con 2 digitos
begin
case(count_data) 

8'd1: begin digit1 = 4'b0000; digit0 = 4'b0001; end
8'd2: begin digit1 = 4'b0000; digit0 = 4'b0010; end
8'd3: begin digit1 = 4'b0000; digit0 = 4'b0011; end
8'd4: begin digit1 = 4'b0000; digit0 = 4'b0100; end
8'd5: begin digit1 = 4'b0000; digit0 = 4'b0101; end
8'd6: begin digit1 = 4'b0000; digit0 = 4'b0110; end
8'd7: begin digit1 = 4'b0000; digit0 = 4'b0111; end
8'd8: begin digit1 = 4'b0000; digit0 = 4'b1000; end
8'd9: begin digit1 = 4'b0000; digit0 = 4'b1001; end

8'd10: begin digit1 = 4'b0001; digit0 = 4'b0000; end
8'd11: begin digit1 = 4'b0001; digit0 = 4'b0001; end
8'd12: begin digit1 = 4'b0001; digit0 = 4'b0010; end

default:  begin digit1 = 0; digit0 = 0; end
endcase
end

assign datos_mes = {digit1,digit0};

endmodule
