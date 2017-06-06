`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2017 02:23:39 PM
// Design Name: 
// Module Name: Signal_Gen_TB
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


module Signal_Gen_TB(
    );
       reg clk;
       reg reset;
       reg in_escribir_leer; //Se\~nal exterior que indica si se debe de iniciar cualquier proceso (esc o leer)
       reg en_funcion; 
       wire reg_a_d; //Senales de control RTC
       wire reg_cs;
       wire reg_wr;
       wire reg_rd;
       wire out_direccion_dato; //Dato captura
       wire flag_done; //finalizacion del proceso
    
        
       Ctrl_RTC_Sig instancia (
            .clk(clk),
            .reset(reset),
            .in_escribir_leer(in_escribir_leer), //Se\~nal exterior que indica si se debe de iniciar cualquier proceso (esc o leer)
            .en_funcion(en_funcion), 
            .reg_a_d(reg_a_d), //Senales de control RTC
            .reg_cs(reg_cs),
            .reg_wr(reg_wr),
            .reg_rd(reg_rd),
            .out_direccion_dato(out_direccion_dato), //Dato captura
            .flag_done(flag_done) //finalizacion del proceso
       );
       
       
     //  always #10 clk = ~clk;
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
               // Initialize Inputs
               #10 reset = 1'b1;
               //reg_a_d=1'b0; //Senales de control RTC
               //reg_cs=1'b0;
               //reg_wr=1'b0;
               //reg_rd=1'b0;
               //port_id = 0;
               //in_dato = 0;
               in_escribir_leer=1'b0;
               en_funcion=1'b0;
               //out_direccion_dato=1'b0; //Dato captura
               //flag_done=1'b0;
               //write_strobe = 0;
               //read_strobe = 0;
               #20 reset = 1'b0;
               //#20 port_id = 8'h0E;
               #50 en_funcion=1'b1;
               //in_dato = 8'h01;
               //#20 port_id = 8'h00;
               #70 in_escribir_leer=1'b0;
               //in_dato = 8'h21;
               //#20 port_id = 8'h01;
               //in_dato = 8'h01;
               
               
               
               #100000 $stop;
               
               // Wait 100 ns for global reset to finish
               
               
               // Add stimulus here
       end
       
       endmodule
    

