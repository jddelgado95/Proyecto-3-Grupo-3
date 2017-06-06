`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2017 06:10:05 PM
// Design Name: 
// Module Name: Ctrl_RTC_Sig
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


module Ctrl_RTC_Sig(
    input wire clk,
	input wire reset,
	input wire in_escribir_leer, //Se\~nal exterior que indica si se debe de iniciar cualquier proceso (esc o leer)
	input wire en_funcion, //Senal que activa el inicio de la secuencia de las senales de CTRL 
	output reg reg_a_d, //Senales de control RTC
	//Senales de CTRL del RTC
	//***************************
	output reg reg_cs,
	output reg reg_wr,
	output reg reg_rd,
	//****************************
	output reg out_direccion_dato, //Dato captura
	output wire flag_done //finalizacion del proceso
	  
    ); 
    /////parametros de variables para los estados de la FSM
    localparam
    espera = 1'b1,
    leer_escribir = 1'b0;
         
    // Bits del contador para generar una señal periódica de (2^N)*10ns
    
    localparam N = 5;
    
    // Declaración de señales para el contador y la FSM
    reg [N-1:0] q_reg;
    reg [N-1:0] q_next;
    reg state_reg, state_next;
    reg reset_count;
    
    //Descripción del comportamiento
    
    //=============================================
    // Contador para generar un pulso de(2^N)*10ns
    //=============================================
    always @(posedge clk, posedge reset_count)
    begin
        if (reset_count) q_reg <= 0; //el contador se reinicia
         else  q_reg <= q_next;	 //sino cuenta +1
    end
    always@*
    begin
    q_next <= q_reg + 1'b1; //define que el qnext va a ser el contador +1
    end
    
    // Pulso de salida
    assign flag_done = (q_reg == 23) ? 1'b1 : 1'b0;//Tbandera fin de proseso, cuando cuenta a 23 pulsos, el proceso se detiene o reinica
    
     
    ///logica secuencial de la FSM
    always @(posedge clk, posedge reset)
    begin
      if (reset)
         state_reg <= espera;
      else
         state_reg <= state_next;
    end
    
    // Lógica de estado siguiente y salida
      always@*
       begin
        state_next = state_reg;  // estado actual
        case(state_reg)
        espera: 
        //estado de ESPERA, las senales esperan un estimulo para iniciar la cuenta (Reset=0)
        //Tambien ocupan que el ID PORT (0E), active la senal de en funcion, para que la secuencia de senales empiece
          begin
                reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0; //no ha capturado un dato
                reset_count = 1'b1; //el contador no esta contando
                if(en_funcion) state_next = leer_escribir; //si hay pulso, pasa al estado siguiente
                else state_next = espera; // sino se mantiene en el actual
            end
            
        leer_escribir:
        begin
        reset_count = 1'b0; // contador empieza a contar
        //Proseso de lectura_escritura	
        case(q_reg)
            5'd0: begin //inicia 
                reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_rd = 1'b1;
                reg_wr = 1'b1;
                out_direccion_dato = 1'b0;
            end 
            5'd1: begin // baja salida a_d
                reg_a_d = 1'b0;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            
            5'd2: begin// baja cs con wr o rd incio de manipulacion del bits de datos
                reg_a_d = 1'b0;
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
                end
                //las senales van a fluctuar un rato hasta que reciban otro estimulo para que escriba o lea
            5'd3: begin
                reg_a_d = 1'b0;
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            5'd4: begin
                reg_a_d = 1'b0;
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
                end
            5'd5: begin
                reg_a_d = 1'b0;
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
                end
            5'd6: begin
                reg_a_d = 1'b0;
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            5'd7: begin
                reg_a_d = 1'b0;
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            
            5'd8: begin
                reg_a_d = 1'b0;
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
                end
                
            5'd9:begin 
                reg_a_d = 1'b0;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            5'd10: begin
                reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            5'd11: begin
                reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            5'd12: begin
                reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            5'd13: begin
                reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
                end
            5'd14: begin
                reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b0;
            end
            5'd15: begin
                reg_a_d = 1'b1;
                out_direccion_dato = 1'b1; //puede recibir una direccion o un dato
                if (in_escribir_leer)begin
                //escribe si escribir_leer=1
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                end
                else begin //Lee si escribir_leer=0
                reg_cs = 1'b0;
                reg_wr = 1'b1;
                reg_rd = 1'b0;
            end
            end
            5'd16:begin
                reg_a_d = 1'b1;
                out_direccion_dato = 1'b1;
                if (in_escribir_leer)begin
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                end
                else begin
                reg_cs = 1'b0;
                reg_wr = 1'b1;
                reg_rd = 1'b0;
            end
            end
            5'd17:begin
                reg_a_d = 1'b1;
                out_direccion_dato = 1'b1;
                if (in_escribir_leer)begin
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                end
                else begin
                reg_cs = 1'b0;
                reg_wr = 1'b1;
                reg_rd = 1'b0;
                end
            end
            5'd18:begin
                reg_a_d = 1'b1;
                out_direccion_dato = 1'b1;
                if (in_escribir_leer)begin
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                end
                else begin
                reg_cs = 1'b0;
                reg_wr = 1'b1;
                reg_rd = 1'b0;
                end
            end
            5'd19: begin
                reg_a_d = 1'b1;
                out_direccion_dato = 1'b1;
                if (in_escribir_leer)begin
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                end
                else begin
                reg_cs = 1'b0;
                reg_wr = 1'b1;
                reg_rd = 1'b0;
            end
            end
            5'd20: begin
                reg_a_d = 1'b1;
                out_direccion_dato = 1'b1;
                if (in_escribir_leer)begin
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                end
                else begin
                reg_cs = 1'b0;
                reg_wr = 1'b1;
                reg_rd = 1'b0;
            end
            end
            5'd21: begin
                reg_a_d = 1'b1;
                out_direccion_dato = 1'b1;
                if (in_escribir_leer)begin
                reg_cs = 1'b0;
                reg_wr = 1'b0;
                reg_rd = 1'b1;
                end
                else begin
                reg_cs = 1'b0;
                reg_wr = 1'b1;
                reg_rd = 1'b0;
            end end
            
            5'd22: begin reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1;
                out_direccion_dato = 1'b1;
                end
            5'd23://vuelve a las mismas senales del estado de espera
            begin reg_a_d = 1'b1;
                reg_cs = 1'b1;
                reg_wr = 1'b1;
                reg_rd = 1'b1; 
                out_direccion_dato = 1'b0;
                state_next = espera;
            end
             
            default: begin //el default va a ser siempre esperar el estimulo inicial
            state_next = leer_escribir;
            reg_a_d = 1'b1;
            reg_cs =  1'b1;
            reg_rd =  1'b1;
            reg_wr =  1'b1;
            out_direccion_dato =  1'b0;
            end 
            endcase	 
        end
        default: begin
        state_next = espera;
        reg_cs = 1'd1;
        reg_a_d = 1'd1;
        reg_wr = 1'd1;
        reg_rd = 1'd1;
        out_direccion_dato = 1'd0;
        end
        endcase
        
    end

endmodule
