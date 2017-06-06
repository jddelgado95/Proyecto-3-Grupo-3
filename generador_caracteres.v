`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2017 11:01:54 PM
// Design Name: 
// Module Name: generador_caracteres
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


module generador_caracteres
(
input wire clk,
input wire [3:0] digit0_HH, digit1_HH, digit0_MM, digit1_MM, digit0_SS, digit1_SS,//
digit0_DAY, digit1_DAY, digit0_MES, digit1_MES, digit0_YEAR, digit1_YEAR,//
digit0_HH_T, digit1_HH_T, digit0_MM_T, digit1_MM_T, digit0_SS_T, digit1_SS_T,//Decenas y unidades para los números en pantalla (18 inputs de 4 bits)
input wire AM_PM,//Entrada para conocer si en la información de hora se despliega AM o PM
input wire parpadeo,//Señal para el parpadeo de los cursores
input wire [1:0] config_mode,//2 bits para los estados de la configuración
input wire [1:0] cursor_location,//Indica cuál es  la posición del cursor cuando se está en modo configuración
input wire [9:0] pixel_x, pixel_y,
output wire AMPM_on, //bandera para indicar que se está en la posición de pintado de AM_PM
output wire text_on, //bandera para el pintado de los diferentes textos (dígitos)
output reg [11:0] text_RGB // 12 bits de los colores
);



//***************Declaración de señales para la Font ROM***********************************
wire [11:0] rom_addr; //ASCII 7-bits + Fila 5-bits
reg [6:0] char_addr; //ASCII 7-bits
reg [4:0] row_addr; //Direccion de fila del patrón de caracter en particular(5 bits)
reg [3:0] bit_addr; //Columna del pixel particular de un patrón de caracter (4 bits)
wire [15:0] font_word;//Fila de pixeles del patrón de caracter en particular (16 bits)
wire font_bit;//1 pixel del font_word específicado por bit_addr

//Declaración de variables auxiliares,para el manejo de la dirección de los diferentes datos
reg [6:0] char_addr_digHORA, char_addr_digFECHA, char_addr_digTIMER, char_addr_AMPM;
wire [4:0] row_addr_digHORA, row_addr_digFECHA, row_addr_digTIMER,  row_addr_AMPM;
wire [3:0] bit_addr_digHORA, bit_addr_digFECHA, bit_addr_digTIMER, bit_addr_AMPM; 
wire digHORA_on, digFECHA_on, digTIMER_on;
	
//Instanciación de la font ROM ( en este caso para una mejor definición se utiliza la de 16x32)
ROM_16x32 Instancia_ROM_16x32
(.clk(clk), .addr(rom_addr), .data(font_word));

//***************************Lógica que explica el funcionamiento del generador*********************************

//1.Dígitos para representar la HORA(tamaño de fuente 16x32)
    assign digHORA_on = (pixel_y[9:5]==3)&&(pixel_x[9:4]>=16)&&(pixel_x[9:4]<=23); // para la posición en "x" y "y"
    assign row_addr_digHORA = pixel_y[4:0];
    assign bit_addr_digHORA = pixel_x[3:0];
    
    always@*
    begin
    
        case(pixel_x[6:4])
        3'b000: char_addr_digHORA = {3'b011, digit1_HH};//Para las decenas de hora
        3'b001: char_addr_digHORA = {3'b011, digit0_HH};//Para las Unidades de hora
        3'b010: char_addr_digHORA = 7'h3a;//Para pintar el caracter de :
        3'b011: char_addr_digHORA = {3'b011, digit1_MM};//Para las decenas de minutos
        3'b100: char_addr_digHORA = {3'b011, digit0_MM};//Para las unidades de minutos
        3'b101: char_addr_digHORA = 7'h3a;//Para pintar el caracter de :
        3'b110: char_addr_digHORA = {3'b011, digit1_SS};//Para las decenas de segundos
        3'b111: char_addr_digHORA = {3'b011, digit0_SS};////Para las unidades de segundos
        endcase
        
    end


//2.Dígitos para representar la FECHA(tamaño de fuente 16x32)
    assign digFECHA_on = (pixel_y[9:5]==7)&&(pixel_x[9:4]>=5)&&(pixel_x[9:4]<=12);
    assign row_addr_digFECHA = pixel_y[4:0];
    assign bit_addr_digFECHA = pixel_x[3:0];
    
    always@*
    begin
        case(pixel_x[6:4])
        4'h5: char_addr_digFECHA = {3'b011, digit1_DAY};//Para decenas de día
        4'h6: char_addr_digFECHA = {3'b011, digit0_DAY};//Para unidades de día
        4'h7: char_addr_digFECHA = 7'h2f;//Para el /
        4'h0: char_addr_digFECHA = {3'b011, digit1_MES};//Para decenas de mes
        4'h1: char_addr_digFECHA = {3'b011, digit0_MES};//Para Unidades de mes
        4'h2: char_addr_digFECHA = 7'h2f;//Para el /
        4'h3: char_addr_digFECHA = {3'b011, digit1_YEAR};//Para decenas de año
        4'h4: char_addr_digFECHA = {3'b011, digit0_YEAR};//Para unidades de año 
        endcase    
    end
    
    //3.Dígitos para la cuenta del TIMER (tamaño de fuente 16x32)
    assign digTIMER_on = (pixel_y[9:5]==11)&&(pixel_x[9:4]>=5)&&(pixel_x[9:4]<=12);
    assign row_addr_digTIMER = pixel_y[4:0];
    assign bit_addr_digTIMER = pixel_x[3:0];
    
    always@*
    begin
        case(pixel_x[6:4])
        4'h5: char_addr_digTIMER = {3'b011, digit1_HH_T};//Para las decenas de hora del timer
        4'h6: char_addr_digTIMER = {3'b011, digit0_HH_T};//Para las unidades de hora del timer
        4'h7: char_addr_digTIMER = 7'h3a;//Para los :
        4'h0: char_addr_digTIMER = {3'b011, digit1_MM_T};//Para las decenas de minutos del timer
        4'h1: char_addr_digTIMER = {3'b011, digit0_MM_T};////Para las unidades de hora del timer
        4'h2: char_addr_digTIMER = 7'h3a;//Para los :
        4'h3: char_addr_digTIMER = {3'b011, digit1_SS_T};//Para las decenas de segundos del timer
        4'h4: char_addr_digTIMER = {3'b011, digit0_SS_T};//Para las unidades de segundos del timer
        endcase    
    end

//4.Palabra AM o PM(tamaño de fuente 16x32)
assign AMPM_on = (pixel_y[9:5]==1)&&(pixel_x[9:4]>=26)&&(pixel_x[9:4]<=27);
assign row_addr_AMPM = pixel_y[4:0];
assign bit_addr_AMPM = pixel_x[3:0];

always@*
begin
	case(pixel_x[4])
	
	1'b0:
	begin
	case(AM_PM)//Si AM_PM = 0 -> se escribe AM, de lo contrario, PM
	1'b0: char_addr_AMPM = 7'h61;//A
	1'b1: char_addr_AMPM = 7'h64;//P
	endcase
	end
	
	1'b1: char_addr_AMPM = 7'h63;//M
	endcase	
end

//*******************Multiplexar salidad*********************************************
always @*
begin

text_RGB = 12'h000;//Fondo negro

//*************************Hora*******************************************************
	
	if(digHORA_on)
		begin
		char_addr = char_addr_digHORA;
      row_addr = row_addr_digHORA;
      bit_addr = bit_addr_digHORA;
			//(0: Los dos dígitos a la derecha, 1: Los dos dígitos intermedios, 2: Los dos dígitos a la izquierda, 3: Ubicación de AM/PM)
			//Evalúa que se está configurando (0: modo normal, 1: config.hora, 2: config.fecha, 3: config.timer)
			if(font_bit) text_RGB = 12'hFFF; //Blanco
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 1)&&(pixel_y[9:5]==3)&&(pixel_x[9:4]>=16)&&(pixel_x[9:4]<=17)&&(cursor_location==2)) // 
			text_RGB =12'hFFF;//Hace un cursor que parpadea si se está en modo configuración
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 1)&&(pixel_y[9:5]==3)&&(pixel_x[9:4]>=19)&&(pixel_x[9:4]<=20)&&(cursor_location==1))
			text_RGB = 12'hFFF;//Hace un cursor que parpadea si se está en modo configuración
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 1)&&(pixel_y[9:5]==3)&&(pixel_x[9:4]>=22)&&(pixel_x[9:4]<=23)&&(cursor_location==0))
			text_RGB = 12'hFFF;//Hace un cursor que parpadea si se está en modo configuración
			else if(~font_bit) text_RGB = 12'h000;//Fondo del texto igual al relleno de los recuadros, en este caso son Negros
		end

//*************************Fin de Hora*************************************************
//*************************Fecha*******************************************************

	else if(digFECHA_on)
		begin
		char_addr = char_addr_digFECHA;
     	        row_addr = row_addr_digFECHA;
                bit_addr = bit_addr_digFECHA;
			//(0: Los dos dígitos a la derecha, 1: Los dos dígitos intermedios, 2: Los dos dígitos a la izquierda, 3: Ubicación de día semana)
			if(font_bit) text_RGB =12'hFFF; //Blanco
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 2)&&(pixel_y[9:5]==7)&&(pixel_x[9:4]>=5)&&(pixel_x[9:4]<=6)&&(cursor_location==2))
			text_RGB = 12'hFFF;//Genera el cursor para indicar que se está en modo configuración
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 2)&&(pixel_y[9:5]==7)&&(pixel_x[9:4]>=8)&&(pixel_x[9:4]<=9)&&(cursor_location==1))
			text_RGB = 12'hFFF;//Genera el cursor para indicar que se está en modo configuración
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 2)&&(pixel_y[9:5]==7)&&(pixel_x[9:4]>=11)&&(pixel_x[9:4]<=12)&&(cursor_location==0))
			text_RGB = 12'hFFF;//Genera el cursor para indicar que se está en modo configuración
			else if(~font_bit) text_RGB = 12'h000;//Color del fondo del texto igual al de las cajas que encierran los dígitos
		end

//*************************Fin de fecha***************************************************

//*************************Timer**********************************************************
	
	else if ((digTIMER_on))
		begin
		char_addr = char_addr_digTIMER;
      row_addr = row_addr_digTIMER;
      bit_addr = bit_addr_digTIMER;
			//(0: Los dos dígitos a la derecha, 1: Los dos dígitos intermedios, 2: Los dos dígitos a la izquierda)
			if(font_bit) text_RGB =12'hFFF; //Blanco
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 3)&&(pixel_y[9:5]==11)&&(pixel_x[9:4]>=5)&&(pixel_x[9:4]<=6)&&(cursor_location==2)) 
			text_RGB = 12'hFFF;////Genera el cursor para indicar que se está en modo configuración
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 3)&&(pixel_y[9:5]==11)&&(pixel_x[9:4]>=8)&&(pixel_x[9:4]<=9)&&(cursor_location==1))
			text_RGB = 12'hFFF;////Genera el cursor para indicar que se está en modo configuración
			else if ((parpadeo)&&(~font_bit)&&(config_mode == 3)&&(pixel_y[9:5]==11)&&(pixel_x[9:4]>=11)&&(pixel_x[9:4]<=12)&&(cursor_location==0))
			text_RGB = 12'hFFF;//Genera el cursor para indicar que se está en modo configuración
			else if(~font_bit) text_RGB = 12'h000;//Color del fondo del texto igual al de las cajas que encierran los dígitos
		end
//*************************Fin de timer*******************************************************

//*************************AM_PM***************************************************************
	else if (AMPM_on)
          begin
          char_addr = char_addr_AMPM;
          row_addr = row_addr_AMPM;
          bit_addr = bit_addr_AMPM;
          //(0: Los dos dígitos a la derecha, 1: Los dos dígitos intermedios, 2: Los dos dígitos a la izquierda, 3: Ubicación de AM/PM)
          if(font_bit) text_RGB = 12'h2F2; //Verde
          end   
		
end
//*********************Fin de AM_PM*******************************************************
assign text_on = digHORA_on|digFECHA_on|digTIMER_on;//Para pintar los diferentes datos

//Interfaz con la font ROM
assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr];

endmodule
