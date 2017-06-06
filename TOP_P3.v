`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2017 03:38:39 PM
// Design Name: 
// Module Name: TOP_P3
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


module TOP_P3(
    input wire clk, reset,
    input wire ps2data, //dato de entrada proveniente del teclado, entra al Ctrl de Teclado
    input wire ps2clk, //clk proveniente del teclado, entra al Ctrl de Teclado
    inout [7:0] dato, //inout que extrae datos/direcciones del chip RTC
    output wire AD, CS, WR, RD, //Senales de ctrl para el chip RTC
    output wire aspwm,assd, // 
    output wire [11:0] RGB, //Salida de los colores a pintar del Ctrl de VGA
    output wire hsync, vsync //Senales de sincronizacion del Ctrl de VGA
);

//Conexiones internas
    reg [7:0]in_port;
    wire [7:0]out_port;
    wire [7:0]port_id;
    wire write_strobe;
    wire k_write_strobe;
    wire read_strobe;
    wire interrupt;
    wire alarma_sonora;

    wire [7:0]out_seg_hora,out_min_hora,out_hora_hora;
    wire [7:0]out_dia_fecha,out_mes_fecha,out_jahr_fecha;
    wire [7:0]out_seg_timer,out_min_timer,out_hora_timer;

    wire fin_lectura_escritura;
    wire [7:0] out_dato;
    
    wire [7:0] ascii_code;
    
    assign interrupt = 1'b0;



    Mcontrolador instancia_microcontrolador //Instancia del microcontrolador
    (
        .clk(clk), 
        .reset(reset), 
        .interrupt(interrupt), 
        .in_port(in_port), 
        .write_strobe(write_strobe), 
        .k_write_strobe(k_write_strobe), 
        .read_strobe(read_strobe), 
        .interrupt_ack(), 
        .port_id(port_id), 
        .out_port(out_port)
    );

    Esc_Lec_RTC instancia_escritor_lector_rtc_2  //Instancia del Ctrl de RTC
    (
        .clk(clk), 
        .reset(reset), 
        .in_dato(out_port),
         .port_id(port_id),
         .write_strobe(write_strobe), 
         .k_write_strobe(k_write_strobe),
        .read_strobe(read_strobe),
        .reg_a_d(AD), 
        .reg_cs(CS), 
        .reg_rd(RD), 
        .reg_wr(WR), 
        .out_dato(out_dato), 
        .flag_done(fin_lectura_escritura), 
        .dato(dato)
    );
	 
    Controlador_Teclado instancia_controlador_teclado_ps2 //Instancia del Ctrl de Teclado
    (
        .clk(clk), 
        .reset(reset), 
        .ps2data(ps2data), 
        .ps2clk(ps2clk), 
        .port_id(port_id), 
        .read_strobe(read_strobe), 
        .ascii_code(ascii_code)
    );

    Controlador_VGA instancia_controlador_VGA  //Instancia Ctrl de VGA
    (
        .clock(clk), 
        .reset(reset), 
        .in_dato(out_port), 
        .port_id(port_id), 
        .write_strobe(write_strobe), 
        .k_write_strobe(k_write_strobe), 
        .out_seg_hora(out_seg_hora), 
        .out_min_hora(out_min_hora), 
        .out_hora_hora(out_hora_hora), 
        .out_dia_fecha(out_dia_fecha), 
        .out_mes_fecha(out_mes_fecha), 
        .out_jahr_fecha(out_jahr_fecha), 
        .out_seg_timer(out_seg_timer), 
        .out_min_timer(out_min_timer), 
        .out_hora_timer(out_hora_timer),
    	.alarma_sonora(alarma_sonora),
        .hsync(hsync), 
        .vsync(vsync), 
        .RGB(RGB)
    );
    
    SONIDO gritojeanca(.clk(clk),.reset(reset),.alarma_on(alarma_sonora),.ampPWM(aspwm),.ampSD(assd));
    
    //Decodificación del puerto de entrada del microcontrolador
    //Decodifica los datos que van a ingresar al in port del Mcontrolador.
    always@(posedge clk)
    begin
            case (port_id) 
            8'h0F : in_port <= fin_lectura_escritura; //bandera que indica cuando finalizo el proceso de escritura o lectura del generador de senales
            8'h10 : in_port <= out_dato; //dato del bus bidireccional extraido del chip RTC
            8'h02 : in_port <= ascii_code;//salida del controlador de teclado
    		8'h12 : in_port <= out_seg_hora;
    		8'h13 : in_port <= out_min_hora;
    		8'h14 : in_port <= out_hora_hora;
    		8'h15 : in_port <= out_dia_fecha;
    		8'h16 : in_port <= out_mes_fecha;
    		8'h17 : in_port <= out_jahr_fecha;
    		8'h18 : in_port <= out_seg_timer;
    		8'h19 : in_port <= out_min_timer;
    		8'h1A : in_port <= out_hora_timer;
          default : in_port <= 8'bXXXXXXXX;  
        endcase
    end

endmodule
