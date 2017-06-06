`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 10:59:03 PM
// Design Name: 
// Module Name: Prueba_Contabilidad_2
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


module Prueba_Contabilidad_2();
    
    reg clk, reset;
reg ps2data;
reg ps2clk; 
wire [7:0] dato;
wire AD, CS, WR, RD;
//wire alarma_sonora;
//wire [7:0] RGB;
//wire hsync, vsync;

	// Instantiate the Unit Under Test (UUT)
	 TOP_P3 instancia(
     .clk(clk), 
     .reset(reset),
     .ps2data(ps2data), 
     .ps2clk(ps2clk), 
     .dato(dato),
     .AD(AD), 
     .CS(CS),
     .WR(WR), 
     .RD(RD)
     //.alarma_sonora(alarma_sonora),
     //.RGB(RGB),
     //.hsync(hsync),
     //.vsync(vsync)
   );
	always #10 clk=~clk;
	always #4000 ps2clk=~ps2clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		ps2data = 1;
		ps2clk = 0;
		//rx_en = 1;

		// Wait 100 ns for global reset to finish
		#100 reset = 0; 
		#100 reset = 1;		 
		 #100 reset = 0;
  
			#8000
			ps2data = 1;
			#80000 ps2data = 0; //inicio 
			//byte de datos
			#8000 ps2data = 1;
			#8000 ps2data = 0;
			#8000 ps2data = 0;
			#8000 ps2data = 0;
			#8000 ps2data = 0;
			#8000 ps2data = 0;
			#8000 ps2data = 1;
			#8000 ps2data = 1;
			//paridad
			#8000 ps2data = 0;
			//final
			#8000 ps2data = 1;
			#180000

		$stop;


	end
endmodule
    
 
