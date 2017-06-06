`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2017 11:43:47 PM
// Design Name: 
// Module Name: ControlRTC_TB
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


module ControlRTC_TB(
 );
 
 // Inputs
     reg clk;
     reg reset;
     reg [7:0] port_id;
     reg [7:0] in_dato;
     reg write_strobe;
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
    Esc_Lec_RTC instancia (
         .clk(clk), 
         .reset(reset), 
         .port_id(port_id), 
         .in_dato(in_dato), 
         .write_strobe(write_strobe), 
         .read_strobe(read_strobe), 
         .reg_a_d(reg_a_d), 
         .reg_cs(reg_cs), 
         .reg_rd(reg_rd), 
         .reg_wr(reg_wr), 
         .out_dato(out_dato), 
         .flag_done(flag_done),
         //.fin_lectura_escritura(fin_lectura_escritura), 
         .dato(dato)
     );
 always #10 clk = ~clk;
 /*
 reg count;
 always @ (posedge clk) begin
     count = count + 1'b1;
 end
 always @(negedge count) begin
     
 end
 */
     initial begin
         // Initialize Inputs
         clk = 0;
         reset = 1;
         port_id = 0;
         in_dato = 0;
         write_strobe = 0;
         read_strobe = 0;
         #10 reset = 0;
         #20 port_id=8'h0E;
         write_strobe=1'b1;
        #400 port_id = 8'h00;
         in_dato = 8'h01;
         #410 port_id=8'h0E;
//         #460 port_id = 8'h00;
//         in_dato = 8'h21;
//         #510 port_id = 8'h01;
//         in_dato = 8'h01;
//         #550 port_id=8'h0F;
//         read_strobe=1'b1;
        #410 read_strobe=1'b1;
        port_id=8'h0F;         
         #100000 $stop;
         
         // Wait 100 ns for global reset to finish
         
         
         // Add stimulus here
 end
 
endmodule
