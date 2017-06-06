`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2017 08:30:25 AM
// Design Name: 
// Module Name: Esc_Lec_TB
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


module Esc_Lec_TB();

// Inputs
	reg clk;
	reg reset;
	reg [7:0] port_id;
	reg [7:0] in_dato;
	reg write_strobe;
	reg k_write_strobe;
	reg read_strobe;

	// Outputs
	wire reg_a_d;
	wire reg_cs;
	wire reg_rd;
	wire reg_wr;
	wire [7:0] out_dato;
	wire flag_done;
	//wire [7:0] fin_lectura_escritura;

	// Bidirs
	wire [7:0] dato;

	// Instantiate the Unit Under Test (UUT)
	Esc_Lec_RTC uut (
		.clk(clk), 
		.reset(reset), 
		.port_id(port_id), 
		.in_dato(in_dato), 
		.write_strobe(write_strobe), 
		.k_write_strobe(k_write_strobe),
		.read_strobe(read_strobe), 
		.reg_a_d(reg_a_d), 
		.reg_cs(reg_cs), 
		.reg_rd(reg_rd), 
		.reg_wr(reg_wr), 
		.out_dato(out_dato), 
		.flag_done(flag_done), //aca iba instanciado fin_escritura_lectura
		.dato(dato)
	);
//always #10 clk = ~clk;
/*
reg count;
always @ (posedge clk) begin
	count = count + 1'b1;
end
always @(negedge count) begin
	
end
*/
     always 
     begin
     #5 clk=~clk;
      end
	initial begin
	        clk = 0;
            reset = 1;
            port_id = 0;
            in_dato = 0;
            write_strobe = 0;
            read_strobe = 0;
            k_write_strobe=0;
            #10 reset = 0;
            read_strobe=0;
            write_strobe=1;
            k_write_strobe=1;
            in_dato=8'h21;
            #30 port_id=8'h0E;
            #400 port_id = 8'h01;
            #600  read_strobe=0;
            write_strobe=1;
            k_write_strobe=1;
            //port_id=8'h01;
           // #500 in_dato = 8'hFF;
            #700 port_id = 8'h0F;
            read_strobe=1'b1;
            write_strobe=1'b0;
            k_write_strobe=1'b0;
            //port_id = 8'h00;
            
           //#1000 port_id = 8'h0E;
           // in_dato = 8'h01;
            //#1400 port_id=8'h0E;
//		// Initialize Inputs
//		//clk = 0;
//		#10 reset = 1'b1;
//		port_id = 8'h1E;
//		//in_dato = 8'h00;
//		write_strobe = 1'b0;
//		read_strobe = 1'b0;
//		#50 reset = 1'b0;
//		#60 write_strobe=1'b1;
//		k_write_strobe=1'b1;
//		in_dato=8'h01;
//		#80 port_id=8'h0E;
//		//#150 port_id = 8'h01;
//		//#100 port_id= 8'h00;
//		//in_dato = 8'h21;
//		//in_dato = 8'h01;
//		//#20 port_id = 8'h00;
//		//#120 port_id = 8'h01;
//		//in_dato = 8'h01;
		
		//#500 flag_done=0 ;
		
		#1000 $stop;
		
		
		// Wait 100 ns for global reset to finish
		
        
		// Add stimulus here
end

endmodule
