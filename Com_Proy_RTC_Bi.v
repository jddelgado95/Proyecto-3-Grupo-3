`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2017 06:07:52 PM
// Design Name: 
// Module Name: Com_Proy_RTC_Bi
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


module Com_Proy_RTC_Bi( // se encarga de ordenar hacia donde van los datos extraidos del RTC o del Picoblaze
	input clk,
	input in_flag_escritura,//bandera para capturar dato
	input in_flag_lectura,
	input in_direccion_dato,
	input [7:0]in_dato,//Datos de entrada para rtc
	output reg [7:0]out_reg_dato,//Datos de salida para el decodificador a la entrada del Mcontrolador
	input [7:0]addr_RAM,//Dato de direccion para RAM
	inout tri [7:0]dato //Dato de RTC
    );
    
    reg [7:0]dato_secundario;
    reg [7:0]next_out_dato;
    
     
    // ASIGNACION DE BUS DE 3 ESTADOS
    assign dato = (in_flag_escritura)? dato_secundario : 8'bZ; //aca se asignan los 3 estados que debe de cumplir la entrada en triestado
    //Si el dato se capturo, se coloca en alta impedancia, sino, sigue en su captura
    //LOGICA SECUENCIAL
    always@(posedge clk) begin
        out_reg_dato <= next_out_dato;
    end
    
    //CONTROLADOR DE SALIDA
    always @(*)
    begin
        case({in_flag_escritura,in_flag_lectura,in_direccion_dato})
            3'b000: begin dato_secundario = 8'd0; //NO DEBE PASAR, el dato esta en alta impedancia
            next_out_dato = out_reg_dato;
            end
            3'b011: begin dato_secundario = 8'd0;//LEER DATO (Hay direccion y una lectura, se debe de leer un DATO del RTC en esa direccion dada)
            next_out_dato = dato;
            end 
            3'b100: begin dato_secundario = addr_RAM;// ESCRIBIR DIRECCION RAM
            next_out_dato = out_reg_dato;
            end 
            3'b101: begin  dato_secundario = in_dato;// ESCRIBE DATO (hay dato y direccion, entonces se debe de escribir iun DATO en el RTC en la direccion dada)
            next_out_dato = out_reg_dato;
            end
            default: begin
            dato_secundario = 8'd0; //NO DEBE PASAR, alta impedancia
            next_out_dato = out_reg_dato;
            end
        
        endcase
    end


endmodule
