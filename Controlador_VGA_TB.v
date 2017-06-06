`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2017 08:31:30 AM
// Design Name: 
// Module Name: Controlador_VGA_TB
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


module Controlador_VGA_TB();


reg clock, reset;
reg[7:0] in_dato, port_id; // Bus de datos de 8 bits / para direccionar el dato 
reg write_strobe, k_write_strobe;// bandera para indicar que se está escribiendo
wire [7:0]out_seg_hora,out_min_hora,out_hora_hora;// Datos de hora
wire [7:0]out_dia_fecha,out_mes_fecha,out_jahr_fecha;// Datos de fecha
wire [7:0]out_seg_timer,out_min_timer,out_hora_timer;// Datos del timer
wire alarma_sonora;//Para sacar la señal para la alarma sonora
wire hsync, vsync;// Para la exploración vertical y horizontal
wire [11:0] RGB; // Salida de 12 bits para la combinación de los colores
wire [9:0] pixel_x,pixel_y;
wire video_on;

// Se instancia el Top del controlador de VGA
Controlador_VGA Instancia(
.clock(clock),
.reset(reset),
.in_dato(in_dato),
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
.alarma_sonora(alarma_sonora),//Para sacar la señal para la alarma sonora
.hsync(hsync), 
.vsync(vsync),
.pixel_x(pixel_x),
.pixel_y(pixel_y),
.video_on(video_on),
.RGB(RGB));


// Se declaran enteros para el contador 
integer i;
integer j;

// La siguinete información es para probar que los datos se están direccinando de forma adecuada y para ello se utiliza la dirección 03 hex y en la simulación debería verse en la salida de segundos de hora.
initial 
begin

clock = 0;
reset = 0;

write_strobe=1; 
k_write_strobe=1;
in_dato=8'b00001010;
port_id=8'h03;




// ESperar 100 ns para un reset general 
#100
reset=1;
#10
reset=0;
#10
reset = 1;
j=0;		
#50
reset = 0;
		
//Para generar el archivo txt y así poder procesarlo con Python
i = $fopen("Interfaz.txt","w"); // Se abre el archivo
    for(j=0;j<383520;j=j+1) begin 
    #40
    if(video_on) 
    begin
    $fwrite(i,"%h",RGB); // para escribir la información en hexadecimal
    end
    else if(pixel_x==641)
    $fwrite(i,"\n");
    end


		    #16800000


		    reset=0; // cierra el archivo
		    $fclose(i);
		    $stop;

end


always #10 clock=~clock; // para generar la señal de reloj










endmodule
