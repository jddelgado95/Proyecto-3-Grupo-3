`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2017 02:05:22 PM
// Design Name: 
// Module Name: Controlador_VGA
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


module Controlador_VGA(
input wire clock, reset,
input wire [7:0] in_dato, port_id, // Dato de entrada de 8 bits, el cual se direcciona con el port_id, según lo establecido en el mapeo de periféricos
input wire write_strobe, k_write_strobe, // Para indicar que el Microcontrolador está escribiendo
output wire [7:0]out_seg_hora,out_min_hora,out_hora_hora, // Datos de salida de hora
output wire [7:0]out_dia_fecha,out_mes_fecha,out_jahr_fecha, // Datos de salida de fecha
output wire [7:0]out_seg_timer,out_min_timer,out_hora_timer,// Datos de salida de timer
output reg alarma_sonora,//Señal para la el sonido de la alarma
output wire hsync, vsync, // Para las exploraciones verticales y horizontales en el monitos (640x480)
output wire [9:0] pixel_x, pixel_y, // Ubicación actual de cada pixel (se sacan para poder realizar los tb)
output wire video_on, // Para indicar si se está en la zona de display (se sacan para poder realizar los tb)
output wire [11:0] RGB
);


//Declaración de conexiones internas
//wire [9:0] pixel_x,pixel_y;
//wire video_on; 
wire pixel_tick; // Para la señal de sincronización de 25 MHz
reg [11:0] RGB_reg, RGB_next; 
wire text_on, graph_on, pic_on; // Banderas para indicar que se está en la región de display de el texto, caja e iamgenes
wire [11:0] fig_RGB, text_RGB, pic_RGB;
wire pic_ring_on; // bandera para pintar el logo de la alarma
wire AMPM_on; // bandera para pintar AM o PM

//Señales de selección cs para los registros que mantienen los datos de hora, fecha, timer
wire cs_seg_hora; 
wire cs_min_hora; 
wire cs_hora_hora; 
wire cs_dia_fecha; 
wire cs_mes_fecha; 
wire cs_jahr_fecha; 
wire cs_seg_timer;
wire cs_min_timer; 
wire cs_hora_timer;

//Señales de control hold para los respectivos registros
wire hold_seg_hora; 
wire hold_min_hora; 
wire hold_hora_hora; 
wire hold_dia_fecha; 
wire hold_mes_fecha; 
wire hold_jahr_fecha; 
wire hold_seg_timer;
wire hold_min_timer; 
wire hold_hora_timer;
wire hold_banderas_config;

//Salida de los contadores hacia los registros
wire [7:0]count_seg_hora; 
wire [7:0]count_min_hora; 
wire [7:0]count_hora_hora; 
wire [7:0]count_dia_fecha; 
wire [7:0]count_mes_fecha; 
wire [7:0]count_jahr_fecha; 
wire [7:0]count_seg_timer;
wire [7:0]count_min_timer; 
wire [7:0]count_hora_timer;

wire [1:0]out_banderas_config; 
 
wire [1:0] config_mode, cursor_location;
wire AM_PM;

//Para generar parpadeo de 4 Hz
// Bits del contador para generar una señal periódica de (2^N)*10ns
localparam N =24;//~3Hz

reg [N-1:0] blink_reg;
reg blink;

localparam N_cursor = 25;//~2Hz

reg [N_cursor-1:0] blink_cursor_reg;
reg blink_cursor;

//Instancias de los diferentes módulos que conforman el controlador de VGA

timing_generator_VGA instancia_timing_generator_VGA // Instancia del sincronizador
(
.clk(clock),
.reset(reset),
.hsync(hsync),
.vsync(vsync),
.video_on(video_on),
.p_tick(pixel_tick),
.pixel_x(pixel_x), 
.pixel_y(pixel_y)
);

generador_figuras instancia_generador_figuras
(
.video_on(video_on),//señal que indica que se encuentra en la región visible de resolución 640x480
.pixel_x(pixel_x), 
.pixel_y(pixel_y),//coordenadas xy de cada pixel
.graph_on(graph_on),
.fig_RGB(fig_RGB) //12 bpp (4 bits para cada color)
);

generador_caracteres instancia_generador_caracteres
(
.clk(clock),
.digit0_HH(out_hora_hora[3:0]), .digit1_HH(out_hora_hora[7:4]), .digit0_MM(out_min_hora[3:0]), .digit1_MM(out_min_hora[7:4]), .digit0_SS(out_seg_hora[3:0]), .digit1_SS(out_seg_hora[7:4]),//
.digit0_DAY(out_dia_fecha[3:0]), .digit1_DAY(out_dia_fecha[7:4]), .digit0_MES(out_mes_fecha[3:0]), .digit1_MES(out_mes_fecha[7:4]), .digit0_YEAR(out_jahr_fecha[3:0]), .digit1_YEAR(out_jahr_fecha[7:4]),//
.digit0_HH_T(out_hora_timer[3:0]), .digit1_HH_T(out_hora_timer[7:4]), .digit0_MM_T(out_min_timer[3:0]), .digit1_MM_T(out_min_timer[7:4]), .digit0_SS_T(out_seg_timer[3:0]), .digit1_SS_T(out_seg_timer[7:4]),//Decenas y unidades para los números en pantalla (18 inputs de 3 bits)
.AM_PM(AM_PM),//Entrada para conocer si en la información de hora se despliega AM o PM
.config_mode(config_mode),
.cursor_location(cursor_location),//Ayuda a indicar la posición del cursor en modo configuración
.pixel_x(pixel_x), .pixel_y(pixel_y),
.parpadeo(blink_cursor), // para el parpadeo del cursor que le indica al usuario en qué dígito se encuentra
.text_on(text_on), 
.AMPM_on(AMPM_on), //Bandera que indica si se debe pintar AM_PM
.text_RGB(text_RGB) //12 bpp
);

generador_imagenes instancia_generador_imagenes // Módulo que se encarga del procesamiento de las imágenes que conforman la interfaz 
(
.video_on(video_on),//señal que indica que se encuentra en la región visible de resolución 640x480
.pixel_x(pixel_x), 
.pixel_y(pixel_y),
.pic_ring_on(pic_ring_on),
//.pic_ringball_on(pic_ringball_on),
.pic_on(pic_on),
.pic_RGB(pic_RGB) //12 bpp
);

memoria_registros_VGA instancia_memoria_registros_VGA 
(
    .clk(clock), 
    .reset(reset),
	 .formato_hora(out_banderas_config[1]),
    .cs_seg_hora(cs_seg_hora), 
    .cs_min_hora(cs_min_hora), 
    .cs_hora_hora(cs_hora_hora), 
    .cs_dia_fecha(cs_dia_fecha), 
    .cs_mes_fecha(cs_mes_fecha), 
    .cs_jahr_fecha(cs_jahr_fecha), 
    .cs_seg_timer(cs_seg_timer), 
    .cs_min_timer(cs_min_timer), 
    .cs_hora_timer(cs_hora_timer), 
    .hold_seg_hora(hold_seg_hora), 
    .hold_min_hora(hold_min_hora), 
    .hold_hora_hora(hold_hora_hora), 
    .hold_dia_fecha(hold_dia_fecha), 
    .hold_mes_fecha(hold_mes_fecha), 
    .hold_jahr_fecha(hold_jahr_fecha), 
    .hold_seg_timer(hold_seg_timer), 
    .hold_min_timer(hold_min_timer), 
    .hold_hora_timer(hold_hora_timer), 
    .hold_banderas_config(hold_banderas_config), 
    .data_PicoBlaze(in_dato), 
    .count_seg_hora(count_seg_hora), 
    .count_min_hora(count_min_hora), 
    .count_hora_hora(count_hora_hora), 
    .count_dia_fecha(count_dia_fecha), 
    .count_mes_fecha(count_mes_fecha), 
    .count_jahr_fecha(count_jahr_fecha), 
    .count_seg_timer(count_seg_timer), 
    .count_min_timer(count_min_timer), 
    .count_hora_timer(count_hora_timer), 
    .out_seg_hora(out_seg_hora), 
    .out_min_hora(out_min_hora), 
    .out_hora_hora(out_hora_hora), 
    .out_dia_fecha(out_dia_fecha), 
    .out_mes_fecha(out_mes_fecha), 
    .out_jahr_fecha(out_jahr_fecha), 
    .out_seg_timer(out_seg_timer), 
    .out_min_timer(out_min_timer), 
    .out_hora_timer(out_hora_timer), 
    .out_banderas_config(out_banderas_config),
	 .AM_PM(AM_PM)
);

contadores_configuracion instancia_contadores_configuracion (
    .clk(clock), 
    .reset(reset), 
    .in_dato(in_dato), 
    .port_id(port_id), 
    .write_strobe(write_strobe), 
    .k_write_strobe(k_write_strobe), 
    .btn_data_SS(count_seg_hora), 
    .btn_data_MM(count_min_hora), 
    .btn_data_HH(count_hora_hora), 
    .btn_data_YEAR(count_jahr_fecha), 
    .btn_data_MES(count_mes_fecha), 
    .btn_data_DAY(count_dia_fecha), 
    .btn_data_SS_T(count_seg_timer), 
    .btn_data_MM_T(count_min_timer), 
    .btn_data_HH_T(count_hora_timer), 
    .cursor_location(cursor_location), 
    .config_mode(config_mode)
    );

deco_hold_registros instancia_deco_hold_registros (
    .write_strobe(write_strobe), 
    .port_id(port_id),
	 .config_mode(config_mode),
    .hold_seg_hora(hold_seg_hora), 
    .hold_min_hora(hold_min_hora), 
    .hold_hora_hora(hold_hora_hora), 
    .hold_dia_fecha(hold_dia_fecha), 
    .hold_mes_fecha(hold_mes_fecha), 
    .hold_jahr_fecha(hold_jahr_fecha), 
    .hold_seg_timer(hold_seg_timer), 
    .hold_min_timer(hold_min_timer), 
    .hold_hora_timer(hold_hora_timer),
	 .hold_banderas_config(hold_banderas_config)
    );
	 
decodificador_cs_registros instancia_decodificador_cs_registros (
    .funcion_conf(config_mode), 
    .cs_seg_hora(cs_seg_hora), 
    .cs_min_hora(cs_min_hora), 
    .cs_hora_hora(cs_hora_hora), 
    .cs_dia_fecha(cs_dia_fecha), 
    .cs_mes_fecha(cs_mes_fecha), 
    .cs_jahr_fecha(cs_jahr_fecha), 
    .cs_seg_timer(cs_seg_timer), 
    .cs_min_timer(cs_min_timer), 
    .cs_hora_timer(cs_hora_timer)
    );

 // Con la ayuda de un contador es posible generar el parpadeo

always @(posedge clock, posedge reset)
begin
	if (reset)begin blink_reg <= 0; blink <= 0; end
	
	else
	begin
		if (blink_reg == 24'd16666666)
			begin
			blink_reg <= 0;
			blink <= ~blink;
			end
		else
			blink_reg <= blink_reg + 1'b1;
	end
end

//Para generar el sonido de la alarma, a una frecuencia audible
always@*
begin
	if (out_banderas_config[0] && blink) alarma_sonora = 1'b1; // Si hay parpadeo y se está en timer entonces la señal se pone en uno, de lo contrario baja
	else alarma_sonora = 1'b0;
end

//Parpadeo cursor
always @(posedge clock, posedge reset)
begin
	if (reset)begin blink_cursor_reg <= 0; blink_cursor <= 0; end
	
	else
	begin
		if (blink_cursor_reg == 25'd24999999)
			begin
			blink_cursor_reg <= 0;
			blink_cursor <= ~blink_cursor;
			end
		else
			blink_cursor_reg <= blink_cursor_reg + 1'b1;
	end
end		
//____________________________________________________________________________________________________________

//Esta es una sección importante, porque permite multiplexar una de las señales a la salida RGB de 12 bits

always@*
begin

	if(~video_on)
	RGB_next = 12'h000;//Fuera la pantalla visible, fondo negro
	
	else
		if(text_on) RGB_next = text_RGB;
		else if (AMPM_on && out_banderas_config[1]) RGB_next = text_RGB;
		else if (graph_on) RGB_next = fig_RGB;
		else if (pic_on) RGB_next = pic_RGB;
                else if (pic_ring_on && out_banderas_config[0] && blink) RGB_next = pic_RGB;
		else RGB_next = 12'h000;//Fondo negro
end

always @(posedge clock)
if (pixel_tick) RGB_reg <= RGB_next;

//Salida de la señal RGB para le monitor 
assign RGB = RGB_reg;

endmodule
