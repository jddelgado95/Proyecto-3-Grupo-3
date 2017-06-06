`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2017 06:30:37 PM
// Design Name: 
// Module Name: TOP_P3_TB
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


module TOP_P3_TB();

    // Testbench que permite ver el comportamiento de todo el sistema
reg clk, reset;
reg ps2data; //dato de entrada proveniente del teclado, entra al Ctrl de Teclado
reg ps2clk; //clk proveniente del teclado, entra al Ctrl de Teclado
wire [7:0] dato; //inout que extrae datos/direcciones del chip RTC
wire AD, CS, WR, RD; //Senales de ctrl para el chip RTC
wire aspwm,assd; // 
wire [11:0] RGB; //Salida de los colores a pintar del Ctrl de VGA
wire hsync, vsync; //Senales de sincronizacion del Ctrl de VGA

TOP_P3 Instancia(
.clk(clk),
.reset(reset),
.ps2data(ps2data), //dato de entrada proveniente del teclado, entra al Ctrl de Teclado
.ps2clk(ps2clk), //clk proveniente del teclado, entra al Ctrl de Teclado
.dato(dato),//inout que extrae datos/direcciones del chip RTC
.AD(AD),
.CS(CS),
.WR(WR),
.RD(RD),//Senales de ctrl para el chip RTC
.aspwm(aspwm),
.assd(assd), // 
.RGB(RGB), //Salida de los colores a pintar del Ctrl de VGA
.hsync(hsync), 
.vsync(vsync) //Senales de sincronizacion del Ctrl de VGA
);

initial 
begin
clk = 0;
forever #5 clk = ~clk; // Para generar el clock de 100 MHz
end
	

initial begin
// Se inicializan las entradas
reset = 1;
ps2data = 0;
ps2clk = 1;

// Espera de 10ns para el reset
#100;
		
reset = 0;
        
	
// Datos para el manejo del teclado
//F0
#50005
ps2clk = 1;
ps2data = 0;//Se manda el bit de inicio
		
#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 0 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 1 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 2 (1C)
		
#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 3 (1C)
		
#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit 4 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit 5 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit 6 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit 7 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Este corresponte al Bit paridad y es par por ser igual a 1

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Este corresponde al Bit de parada
		
#50000
ps2clk = 0;

//1C
#50000
ps2clk = 1;
ps2data = 0;//Este corresponde al bit de inicio
		
#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 0 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 1 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit 2 (1C)
		
#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit 3 (1C)
		
#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit 4 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 5 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 6 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 0;//Bit 7 (1C)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit paridad (par=1)

#50000
ps2clk = 0;
		
#50000
ps2clk = 1;
ps2data = 1;//Bit parada
		
#50000
ps2clk = 1;
		
#200000$stop;		
end
endmodule
