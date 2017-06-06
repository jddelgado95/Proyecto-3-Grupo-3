`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2017 09:09:25 AM
// Design Name: 
// Module Name: generador_imagenes
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


module generador_imagenes
(
input wire video_on,//señal que indica que nos encontramos en la región de display
input wire [9:0] pixel_x, pixel_y, // Posición actual de cada Pixel
output wire pic_ring_on,
// output wire pic_ringball_on, //Flags para indicar que la alarma está activa 
output wire pic_on,
output wire [11:0] pic_RGB //8 bits para los colores 
);

//***********Parámetros para el tamaño y líneas de texto de las imágenes*******************

reg [11:0] pic_RGB_aux; 


//************************ Imagen Hora****************************************



localparam Hora_x = 102; 
localparam Hora_y = 33; 
localparam Hora_size = 3366; //(102x33)

// Declaración de señales

reg [11:0]  data_color_h [0: Hora_size];
wire [19:0] state_h;
wire Hora_on; // Para pintar la imagen de hora


// Asignación de las coordenadas en las que se va a pintar la imagen

reg signed [10:0] XH= 270; // inicia en x
reg signed [9:0] YH= 32;   // inicia en y

// Lectura de la imagen
initial 
$readmemh ("Hora.list", data_color_h); // almacena la información de los pixeles en una matriz para luego ser procesada

//Para imprimir la imagen en la región deseada
assign Hora_on = (pixel_x>=XH && pixel_x<XH + Hora_x && pixel_y>=YH && pixel_y<YH +Hora_y);

assign state_h  = ((pixel_x-XH)*Hora_y)+(pixel_y-YH); //Para generar el índice de la memoria


//************************ Fin Imagen Hora****************************************

//************************ Imagen Fecha****************************************


localparam Fecha_x = 83; 
localparam Fecha_y = 23; 
localparam Fecha_size = 1909; //(83x23)

// Declaración de señales

reg [11:0]  data_color_f [0: Fecha_size];
wire [19:0] state_f;
wire Fecha_on;


// Asignación de las coordenadas

reg signed [10:0] XF= 110;
reg signed [9:0] YF= 175;

// Lectura de la imagen
initial 
$readmemh ("Fecha.list", data_color_f);

assign Fecha_on = (pixel_x>=XF && pixel_x<XF + Fecha_x && pixel_y>=YF && pixel_y<YF + Fecha_y);

assign state_f  = ((pixel_x-XF)*Fecha_y)+(pixel_y-YF); //Para generar el índice de la memoria

//************************ Fin de Fecha****************************************


//************************ Imagen Timer****************************************


localparam Timer_x = 90; 
localparam Timer_y = 24; 
localparam Timer_size = 2160; //(90x24)

// Declaración de señales

reg [11:0]  data_color_t [0: Timer_size];
wire [19:0] state_t;
wire Timer_on;


// Asignación de las coordenadas

reg signed [10:0] XT= 110;
reg signed [9:0] YT= 310;

// Lectura de la imagen
initial 
$readmemh ("Tempo.list", data_color_t);

//Imprime la imagen de hora dentro de la región
assign Timer_on = (pixel_x>=XT && pixel_x<XT + Timer_x && pixel_y>=YT && pixel_y<YT + Timer_y);

assign state_t  = ((pixel_x-XT)*Timer_y)+(pixel_y-YT); //Para generar el índice de la memoria

//************************Fin Imagen Timer****************************************


//************************ Imagen Reset****************************************


localparam Reset_x = 101; 
localparam Reset_y = 25; 
localparam Reset_size = 2525; //(101x25)

// Declaración de señales

reg [11:0]  data_color_Reset [0: Reset_size];
wire [19:0] state_Reset;
wire Reset_on;


// Asignación de las coordenadas

reg signed [10:0] XReset= 370;
reg signed [9:0] YReset= 165;

// Lectura de la imagen
initial 
$readmemh ("Reset.list", data_color_Reset);

//Imprime la imagen de hora dentro de la región
assign Reset_on = (pixel_x>=XReset && pixel_x<XReset + Reset_x && pixel_y>=YReset && pixel_y<YReset + Reset_y);

assign state_Reset  = ((pixel_x-XReset)*Reset_y)+(pixel_y-YReset); //Para generar el índice de la memoria

//************************Fin de Imagen Reset****************************************

//************************ Imagen Salir****************************************


localparam Salir_x = 94; 
localparam  Salir_y = 24; 
localparam  Salir_size = 2256; //(94x24)

// Declaración de señales

reg [11:0]  data_color_Salir [0:  Salir_size];
wire [19:0] state_Salir;
wire Salir_on;


// Asignación de las coordenadas

reg signed [10:0] XSalir= 370;
reg signed [9:0] YSalir= 205;

// Lectura de la imagen
initial 
$readmemh ("Salir.list", data_color_Salir);

//Imprime la imagen de hora dentro de la región
assign Salir_on = (pixel_x>=XSalir && pixel_x<XSalir + Salir_x && pixel_y>=YSalir && pixel_y<YSalir + Salir_y);

assign state_Salir  = ((pixel_x-XSalir)*Salir_y)+(pixel_y-YSalir); //Para generar el índice de la memoria

//************************ Fin Imagen Salir****************************************

//********************** Imagen Formato****************************************


localparam Formato_x = 120; 
localparam  Formato_y = 24; 
localparam  Formato_size = 2880;
// Declaración de señales

reg [11:0]  data_color_Formato [0:  Formato_size];
wire [19:0] state_Formato;
wire Formato_on;


// Asignación de las coordenadas

reg signed [10:0] XFormato= 370;
reg signed [9:0] YFormato= 245;

// Lectura de la imagen
initial 
$readmemh ("Formato.list", data_color_Formato);

//Imprime la imagen de Formato dentro de la región
assign Formato_on = (pixel_x>=XFormato && pixel_x<XFormato + Formato_x && pixel_y>=YFormato && pixel_y<YFormato + Formato_y);

assign state_Formato  = ((pixel_x-XFormato)*Formato_y)+(pixel_y-YFormato); //Para generar el índice de la memoria

//************************ Fin Imagen Formato****************************************

//*********************** Imagen Detener*********************************************


localparam Det_x = 158; 
localparam  Det_y = 22; 
localparam  Det_size = 3476;
// Declaración de señales

reg [11:0]  data_color_Det [0:  Det_size];
wire [19:0] state_Det;
wire Det_on;


// Asignación de las coordenadas

reg signed [10:0] XDet= 370;
reg signed [9:0] YDet= 285;

// Lectura de la imagen
initial 
$readmemh ("Detener.list", data_color_Det);

//Imprime la imagen de Detener dentro de la región
assign Det_on = (pixel_x>=XDet && pixel_x<XDet + Det_x && pixel_y>=YDet && pixel_y<YDet + Det_y);

assign state_Det  = ((pixel_x-XDet)*Det_y)+(pixel_y-YDet); //Para generar el índice de la memoria

//************************ Fin Imagen Detener****************************************

//************************ Imagen ProgF****************************************


localparam ProgF_x = 155; 
localparam ProgF_y = 33; 
localparam ProgF_size = 5115;
// Declaración de señales

reg [11:0]  data_color_ProgF [0:  ProgF_size];
wire [19:0] state_ProgF;
wire ProgF_on;


// Asignación de las coordenadas

reg signed [10:0] XProgF= 370;
reg signed [9:0] YProgF= 325;

// Lectura de la imagen
initial 
$readmemh ("ProgF.list", data_color_ProgF);

//Imprime la imagen dentro de la región
assign ProgF_on = (pixel_x>=XProgF && pixel_x<XProgF + ProgF_x && pixel_y>=YProgF && pixel_y<YProgF + ProgF_y);

assign state_ProgF  = ((pixel_x-XProgF)*ProgF_y)+(pixel_y-YProgF); //Para generar el índice de la memoria

//************************ Fin Imagen ProgF****************************************

//************************ Imagen ProgH****************************************



localparam ProgH_x = 155; 
localparam ProgH_y = 31; 
localparam ProgH_size = 4805;
// Declaración de señales

reg [11:0]  data_color_ProgH [0:  ProgH_size];
wire [19:0] state_ProgH;
wire ProgH_on;


// Asignación de las coordenadas

reg signed [10:0] XProgH= 370;
reg signed [9:0] YProgH= 365;

// Lectura de la imagen
initial 
$readmemh ("ProgH.list", data_color_ProgH);

//Imprime la imagen dentro de la región
assign ProgH_on = (pixel_x>=XProgH && pixel_x<XProgH + ProgH_x && pixel_y>=YProgH && pixel_y<YProgH + ProgH_y);

assign state_ProgH  = ((pixel_x-XProgH)*ProgH_y)+(pixel_y-YProgH); //Para generar el índice de la memoria

//************************FIn Imagen ProgH****************************************

//************************ Imagen ProgT****************************************



localparam ProgT_x = 152; 
localparam ProgT_y = 32; 
localparam ProgT_size = 4864;
// Declaración de señales

reg [11:0]  data_color_ProgT [0:  ProgT_size];
wire [19:0] state_ProgT;
wire ProgT_on;


// Asignación de las coordenadas

reg signed [10:0] XProgT= 370;
reg signed [9:0] YProgT= 405;

// Lectura de la imagen
initial 
$readmemh ("ProgT.list", data_color_ProgT);

//Imprime la imagen de  dentro de la región
assign ProgT_on = (pixel_x>=XProgT && pixel_x<XProgT + ProgT_x && pixel_y>=YProgT && pixel_y<YProgT + ProgT_y);

assign state_ProgT = ((pixel_x-XProgT)*ProgT_y)+(pixel_y-YProgT); //Para generar el índice de la memoria

//************************Fin Imagen ProgH****************************************

//************************ Imagen Alarma****************************************


localparam Ring_x = 98; 
localparam Ring_y = 98; 
localparam Ring_size = 9604;
// Declaración de señales

reg [11:0]  data_color_Ring [0:  Ring_size];
wire [19:0] state_Ring;
wire Ring_on;


// Asignación de las coordenadas

reg signed [10:0] XRing= 180;
reg signed [9:0] YRing= 375;

// Lectura de la imagen
initial 
$readmemh ("Imperial.list", data_color_Ring);

//Imprime la imagen  dentro de la región
assign pic_ring_on = (pixel_x>=XRing && pixel_x<XRing + Ring_x && pixel_y>=YRing && pixel_y<YRing + Ring_y);

assign state_Ring = ((pixel_x-XRing)*Ring_y)+(pixel_y-YRing); //Para generar el índice de la memoria

//************************FIn Imagen Alarma****************************************


//************************Imagen Logo reloj****************************************

localparam Reloj_x = 92; 
localparam Reloj_y = 92; 
localparam Reloj_size = 8464; //(92x92)

// Declaración de señales

reg [11:0]  data_color_r [0: Reloj_size];
wire [19:0] state_r;
wire Reloj_on;


// Asignación de las coordenadas

reg signed [10:0] XR= 40;
reg signed [9:0] YR= 20;

// Lectura de la imagen
initial 
$readmemh ("Reloj.list", data_color_r);

//Imprime la imagen  dentro de la región
assign Reloj_on = (pixel_x>=XR && pixel_x<XR + Reloj_x && pixel_y>=YR && pixel_y<YR + Reloj_y);

assign state_r  = ((pixel_x-XR)*Reloj_y)+(pixel_y-YR); //Para generar el índice de la memoria

//************************Fin Imagen Logo reloj****************************************

//************************Imagen Flechas**********************************************

localparam Flechas_x = 102; 
localparam Flechas_y = 70; 
localparam Flechas_size = 7490; //(92x92)

// Declaración de señales

reg [11:0]  data_color_Flechas [0: Flechas_size];
wire [19:0] state_Flechas;
wire Flechas_on;


// Asignación de las coordenadas

reg signed [10:0] XFlechas= 523;
reg signed [9:0] YFlechas= 390;

// Lectura de la imagen
initial 
$readmemh ("Flechas.list", data_color_Flechas);

//Imprime la imagen  dentro de la región
assign Flechas_on = (pixel_x>=XFlechas && pixel_x<XFlechas + Flechas_x && pixel_y>=YFlechas && pixel_y<YFlechas + Flechas_y);

assign state_Flechas  = ((pixel_x-XFlechas)*Flechas_y)+(pixel_y-YFlechas); //Para generar el índice de la memoria


//************************Fin Imagen flechas****************************************

//Multiplexar la salida de RGB de 12 bits
always @*
begin	
	if(~video_on)
		pic_RGB_aux = 12'h000;//si está fuera de la región de display entonces pinta negro
	
	else // Sino va pintando cada pixel de la imagen que esté activa
		if(Hora_on) pic_RGB_aux = data_color_h[{state_h}];
		else if (Fecha_on) pic_RGB_aux = data_color_f[{state_f}];
		else if (Timer_on) pic_RGB_aux = data_color_t[{state_t}];
		else if (Reset_on) pic_RGB_aux = data_color_Reset[{state_Reset}];
		else if (Salir_on) pic_RGB_aux = data_color_Salir[{state_Salir}];
		else if (Formato_on) pic_RGB_aux = data_color_Formato[{state_Formato}];
		else if (Det_on) pic_RGB_aux = data_color_Det[{state_Det}];
		else if (ProgF_on) pic_RGB_aux = data_color_ProgF[{state_ProgF}];
		else if (ProgH_on) pic_RGB_aux = data_color_ProgH[{state_ProgH}];
		else if (ProgT_on) pic_RGB_aux = data_color_ProgT[{state_ProgT}];
		else if (pic_ring_on) pic_RGB_aux = data_color_Ring[{state_Ring}];
		else if (Reloj_on) pic_RGB_aux = data_color_r[{state_r}];
		else if (Flechas_on) pic_RGB_aux = data_color_Flechas[{state_Flechas}];
		else pic_RGB_aux = 12'h000;//fondo negro	
end
//assign pic_RGB = 	{pic_RGB_aux[7:5],1'b0,pic_RGB_aux[4:2],1'b0,pic_RGB_aux[1:0],2'b0};	//Rellena pic_RGB para pasar de 12 bits a 12 bits
assign pic_RGB = pic_RGB_aux;//Para 12 bits (Nexys 4)
assign pic_on = Hora_on | Timer_on | Fecha_on|Reset_on|Salir_on|Formato_on|Det_on|ProgF_on|ProgH_on|ProgT_on|Reloj_on|Flechas_on;// bandera para indicar que se debe pintar

endmodule
