`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2017 06:05:26 PM
// Design Name: 
// Module Name: Esc_Lec_RTC
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


module Esc_Lec_RTC( //Modulo TOP del Controlador de RTC
	input wire clk,reset,
	input wire [7:0] in_dato, port_id, //in dato recibe datos y direcciones del RTC, port id es una entrada que recibe la orden a realizar del Mcontrolador
	input wire write_strobe, k_write_strobe, read_strobe, //banderas de lectura, escritura. Habilitan y deshabilitan procesos
	output wire reg_a_d,reg_cs,reg_rd,reg_wr,//senales de CTRL para el RTC
	output wire[7:0]out_dato, //Salida que se conecta al PicoBlaze, es redireccionada de un modulo
	output reg flag_done, //bandera de finalizacion del proceso respectivo
	inout [7:0]dato //Dato extraido del RTC
);
    //Conexiones entre el Generador de Senales y el Bus Bidireccional
    wire fin_lectura_escritura; 
    reg en_funcion; //Activa la secuencia de las senales de CTRL
    reg [7:0]addr_RAM,dato_escribir; 
    reg [7:0]reg_addr_RAM, reg_dato_escribir;
    reg reg_escribir_leer,escribir_leer;
    //Para la máquina de estados que controla el flag_done
    reg state_reg_flag,state_next_flag;
    //conexión interna
    wire direccion_dato;
    /// I/O Datos
    Com_Proy_RTC_Bi  instance_driver_bus_bidireccional ( //instancia bus bidireccional
         .clk(clk),
        .in_flag_escritura(~reg_wr), 
        .in_flag_lectura(~reg_rd), 
        .in_direccion_dato(direccion_dato), //bandera para saber si se debe escribir direccion/dato
        .in_dato(dato_escribir), 
        .out_reg_dato(out_dato),  
        .addr_RAM(addr_RAM), 
        .dato(dato)
        );
    
    //Generador de señales de control
    Ctrl_RTC_Sig instance_signal_control_rtc_generator (
        .clk(clk), 
        .reset(reset), 
        .in_escribir_leer(escribir_leer), 
        .en_funcion(en_funcion),
        .reg_a_d(reg_a_d), 		
        .reg_cs(reg_cs), 
        .reg_wr(reg_wr), 
        .reg_rd(reg_rd), 
        .out_direccion_dato(direccion_dato), 
        .flag_done(fin_lectura_escritura)
        );
    
    //Signal_Ctrl_2 instance_signal_control_rtc_generator (
    //    .clk(clk), 
    //    .reset(reset), 
    //    .in_escribir_leer(escribir_leer), 
    //    .en_funcion(en_funcion),
    //    .reg_a_d(reg_a_d), 		
    //    .reg_cs(reg_cs), 
    //    .reg_wr(reg_wr), 
    //    .reg_rd(reg_rd), 
    //    .out_direccion_dato(direccion_dato), 
    //    .flag_done(fin_lectura_escritura)
    //    );
         
    //Para habilitar el generador de señales	 
    always@(posedge clk)
    begin
        if(port_id == 8'h0E) en_funcion <= 1'b1; //al recibir el periferico 0E, se indica que en funcion debe de ser 1, por lo tanto 
        //inicia la secuencia del RTC 
        else en_funcion <= 1'b0;
    end
    
    // logica secuencial
    always@(negedge clk , posedge reset) begin
        if (reset)begin //No realiza nada, se mantiene en 1 las senales de CTRL
            addr_RAM <= 8'h0;
            dato_escribir <= 8'h0;
            escribir_leer <= 1'b0;
        end
        else begin
            addr_RAM <= reg_addr_RAM;
            dato_escribir <= reg_dato_escribir;
            escribir_leer <= reg_escribir_leer;
            
        end
    end
    
    // logica combinacional para port_id
    always@* begin
        //Si recibe el Write o Read Strobe el debe de inicializar algun proceso
        if (write_strobe == 1'b1 || k_write_strobe == 1'b1) begin
        // inicio de secuencia de lectura_escritura rtc
        
        case (port_id)
        8'h00: begin //actualiza direccion
        reg_addr_RAM = in_dato; //El dato proveniente del pico es una direccion a escribir
        reg_dato_escribir = dato_escribir; 
        reg_escribir_leer = escribir_leer;
        end
        8'h01: begin // actualiza dato 
        reg_dato_escribir = in_dato; //dato proveniente del RTC es un dato a escribir
        reg_addr_RAM = addr_RAM;
        reg_escribir_leer = escribir_leer;
        end
        8'h0E: begin // inicia secuancia de rtc, revisar mapeo de perifericos
        reg_addr_RAM = addr_RAM; 
        reg_dato_escribir = dato_escribir;
        reg_escribir_leer = in_dato[0];
        end
        default: begin // si no cumple ninguna de las posibilidades anteriores, se mantiene en lectura
        reg_addr_RAM = addr_RAM;
        reg_dato_escribir = dato_escribir;
        reg_escribir_leer = escribir_leer;
        end
        endcase	
        end
        
        else begin
        reg_addr_RAM = addr_RAM;
        reg_dato_escribir = dato_escribir;
        reg_escribir_leer = escribir_leer;
        end
        
    end
    
    /// maquina de estados para manipular fin lectura escritura
    always @ (negedge clk, posedge reset) begin 
        if (reset) state_reg_flag <= 1'b0;
        else state_reg_flag <= state_next_flag;
    end
    
    always@* 
    begin
    state_next_flag = state_reg_flag;
        case (state_reg_flag)
        1'b0: begin
            flag_done = 8'h00;
            if (fin_lectura_escritura == 1) state_next_flag = 1'b1; // cuando el proceso esta a punto de acabar, se levanta la bandera, pero aun no ha terminado, por lo tanto no baja
            else state_next_flag = 1'b0;
            end
        1'b1: begin
            flag_done = 8'h01;
            if(port_id == 8'h0F && read_strobe == 1)  state_next_flag = 1'b0;//Cuando el micro lee el dato se baja la bandera, indica que el proceso acabo
            else  state_next_flag = 1'b1; //sino continua 		
        end
        endcase
end

endmodule