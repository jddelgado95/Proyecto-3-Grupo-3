`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2017 08:20:12 PM
// Design Name: 
// Module Name: generador_figuras
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


module generador_figuras
(
input wire video_on,//señal que indica que estamos en la región de display
input wire [9:0] pixel_x, pixel_y,//Posición actual de cada pixel
output wire graph_on, // bandera para indicar que se puede pintar
output reg [11:0] fig_RGB  // 12 bits para pintar las cajas o recuadros de la interfaz
);

//Declaración de constantes y señales

//Coordenas xy de la región visible
//localparam MAX_X = 640;
//localparam MAX_Y = 480;

 
//*****************Limites para generar la caja de hora*************************
           
// Borde Superior
localparam Borde_H1_XI = 1; //limite izquierdo de la caja
localparam Borde_H1_XD = 639; //limite derecho de la caja
localparam Borde_H1_YA = 1; //Limite superior de la caja
localparam Borde_H1_YD = 11; //limite inferior de la caja
                   
assign Borde_H1_on = (pixel_x>=Borde_H1_XI)&&(pixel_x<=Borde_H1_XD)&&(pixel_y>=Borde_H1_YA)&&(pixel_y<=Borde_H1_YD); 
                        
//Borde Inferior     
localparam Borde_H2_XI = 1; //limite izquierdo de la caja
localparam Borde_H2_XD = 639; //limite derecho de la caja
localparam Borde_H2_YA = 140; //Limite superior de la caja
localparam Borde_H2_YD = 150; //limite inferior de la caja
                      
assign Borde_H2_on = (pixel_x>=Borde_H2_XI)&&(pixel_x<=Borde_H2_XD)&&(pixel_y>=Borde_H2_YA)&&(pixel_y<=Borde_H2_YD); 
             
             
//Borde Izquierdo
localparam Borde_H3_XI = 1; //limite izquierdo de la caja
localparam Borde_H3_XD = 11; //limite derecho de la caja
localparam Borde_H3_YA = 1; //Limite superior de la caja
localparam Borde_H3_YD = 140; //limite inferior de la caja
                            
assign Borde_H3_on = (pixel_x>=Borde_H3_XI)&&(pixel_x<=Borde_H3_XD)&&(pixel_y>=Borde_H3_YA)&&(pixel_y<=Borde_H3_YD);     
         
//Borde Derecho
                
localparam Borde_H4_XI = 628; //limite izquierdo de la caja
localparam Borde_H4_XD = 638; //limite derecho de la caja
localparam Borde_H4_YA = 1; //Limite superior de la caja
localparam Borde_H4_YD = 140; //limite inferior de la caja
                           
assign Borde_H4_on = (pixel_x>=Borde_H4_XI)&&(pixel_x<=Borde_H4_XD)&&(pixel_y>=Borde_H4_YA)&&(pixel_y<=Borde_H4_YD);
                   
                  
//**************************************************************
//*****************Limites para Fecha *************************
                    
// Borde Superior
localparam Borde_F1_XI = 1; //limite izquierdo de la caja
localparam Borde_F1_XD = 280; //limite derecho de la caja
localparam Borde_F1_YA = 150; //Limite superior de la caja
localparam Borde_F1_YD = 160; //limite inferior de la caja
                            
assign Borde_F1_on = (pixel_x>=Borde_F1_XI)&&(pixel_x<=Borde_F1_XD)&&(pixel_y>=Borde_F1_YA)&&(pixel_y<=Borde_F1_YD); 
                                 
//Borde Inferior     
localparam Borde_F2_XI = 1; //limite izquierdo de la caja
localparam Borde_F2_XD = 280; //limite derecho de la caja                   
localparam Borde_F2_YA = 270; //Limite superior de la caja
localparam Borde_F2_YD = 280; //limite inferior de la caja                   
                                                   
assign Borde_F2_on = (pixel_x>=Borde_F2_XI)&&(pixel_x<=Borde_F2_XD)&&(pixel_y>=Borde_F2_YA)&&(pixel_y<=Borde_F2_YD); 
                      
                      
//Borde Izquierdo
localparam Borde_F3_XI = 1; //limite izquierdo de la caja
localparam Borde_F3_XD = 11; //limite derecho de la caja
localparam Borde_F3_YA = 150; //Limite superior de la caja
localparam Borde_F3_YD = 280; //limite inferior de la caja
                                     
assign Borde_F3_on = (pixel_x>=Borde_F3_XI)&&(pixel_x<=Borde_F3_XD)&&(pixel_y>=Borde_F3_YA)&&(pixel_y<=Borde_F3_YD);     
                  
//Borde Derecho
                         
localparam Borde_F4_XI = 270; //limite izquierdo de la caja
localparam Borde_F4_XD = 280; //limite derecho de la caja
localparam Borde_F4_YA = 150; //Limite superior de la caja
localparam Borde_F4_YD = 280; //limite inferior de la caja
                                  
assign Borde_F4_on = (pixel_x>=Borde_F4_XI)&&(pixel_x<=Borde_F4_XD)&&(pixel_y>=Borde_F4_YA)&&(pixel_y<=Borde_F4_YD);
                            
                           
//**************************************************************
         
//*****************Limites para Timer *************************
                                      
// Borde Superior
localparam Borde_T1_XI = 1; //limite izquierdo de la caja
localparam Borde_T1_XD = 280; //limite derecho de la caja
localparam Borde_T1_YA = 280; //Limite superior de la caja
localparam Borde_T1_YD = 290; //limite inferior de la caja
                                              
assign Borde_T1_on = (pixel_x>=Borde_T1_XI)&&(pixel_x<=Borde_T1_XD)&&(pixel_y>=Borde_T1_YA)&&(pixel_y<=Borde_T1_YD); 
                                                   
 //Borde Inferior     
localparam Borde_T2_XI = 1; //limite izquierdo de la caja
localparam Borde_T2_XD = 280; //limite derecho de la caja
localparam Borde_T2_YA = 468; //Limite superior de la caja
localparam Borde_T2_YD = 478; //limite inferior de la caja
                                                 
assign Borde_T2_on = (pixel_x>=Borde_T2_XI)&&(pixel_x<=Borde_T2_XD)&&(pixel_y>=Borde_T2_YA)&&(pixel_y<=Borde_T2_YD); 
                                        
                                        
//Borde Izquierdo
localparam Borde_T3_XI = 1; //limite izquierdo de la caja
localparam Borde_T3_XD = 11; //limite derecho de la caja
localparam Borde_T3_YA = 280; //Limite superior de la caja
localparam Borde_T3_YD = 478; //limite inferior de la caja
                                                       
assign Borde_T3_on = (pixel_x>=Borde_T3_XI)&&(pixel_x<=Borde_T3_XD)&&(pixel_y>=Borde_T3_YA)&&(pixel_y<=Borde_T3_YD);     
                                    
//Borde Derecho
                                           
localparam Borde_T4_XI = 270; //limite izquierdo de la caja
localparam Borde_T4_XD = 280; //limite derecho de la caja
localparam Borde_T4_YA = 280; //Limite superior de la caja
localparam Borde_T4_YD = 478; //limite inferior de la caja
                                                    
assign Borde_T4_on = (pixel_x>=Borde_T4_XI)&&(pixel_x<=Borde_T4_XD)&&(pixel_y>=Borde_T4_YA)&&(pixel_y<=Borde_T4_YD);
                                              
                                             
                                              
                                    
//*************************************************************
                                    
                                    
                                 
         
           
 //*****************Limites para CONFIGURACIÓN *************************
                           
// Borde Superior
localparam Borde_C1_XI = 280; //limite izquierdo de la caja
localparam Borde_C1_XD = 639; //limite derecho de la caja
localparam Borde_C1_YA = 150; //Limite superior de la caja
localparam Borde_C1_YD = 160; //limite inferior de la caja
                                   
assign Borde_C1_on = (pixel_x>=Borde_C1_XI)&&(pixel_x<=Borde_C1_XD)&&(pixel_y>=Borde_C1_YA)&&(pixel_y<=Borde_C1_YD); 
                                        
//Borde Inferior     
localparam Borde_C2_XI = 280; //limite izquierdo de la caja
localparam Borde_C2_XD = 639; //limite derecho de la caja
localparam Borde_C2_YA = 468; //Limite superior de la caja
localparam Borde_C2_YD = 478; //limite inferior de la caja
                                      
assign Borde_C2_on = (pixel_x>=Borde_C2_XI)&&(pixel_x<=Borde_C2_XD)&&(pixel_y>=Borde_C2_YA)&&(pixel_y<=Borde_C2_YD); 
                             
                             
//Borde Izquierdo
localparam Borde_C3_XI = 280; //limite izquierdo de la caja
localparam Borde_C3_XD = 290; //limite derecho de la caja
localparam Borde_C3_YA = 150; //Limite superior de la caja
localparam Borde_C3_YD = 478; //limite inferior de la caja
                                            
assign Borde_C3_on = (pixel_x>=Borde_C3_XI)&&(pixel_x<=Borde_C3_XD)&&(pixel_y>=Borde_C3_YA)&&(pixel_y<=Borde_C3_YD);     
                         
//Borde Derecho
                                
localparam Borde_C4_XI = 628; //limite izquierdo de la caja
localparam Borde_C4_XD = 638; //limite derecho de la caja
localparam Borde_C4_YA = 150; //Limite superior de la caja
localparam Borde_C4_YD = 478; //limite inferior de la caja
                                         
assign Borde_C4_on = (pixel_x>=Borde_C4_XI)&&(pixel_x<=Borde_C4_XD)&&(pixel_y>=Borde_C4_YA)&&(pixel_y<=Borde_C4_YD);

//*************************************************************                                   
                                         
//Multiplexar la salida RGB
always @*
begin
	if(~video_on) 
	fig_RGB = 12'h000;//fondo negro en caso de no estar en la región de display
	
	
        //****Hora*********  
                                   
        else if (Borde_H1_on)
        begin
        fig_RGB = 12'hF00;//Rojo
        end
                                          
        else if (Borde_H2_on)
        begin
        fig_RGB = 12'hF00;//Rojo
        end
                                              
        else if (Borde_H3_on)
        begin
        fig_RGB = 12'hF00;//Na
        end
                                              
        else if (Borde_H4_on)
        begin
        fig_RGB = 12'hF00;//Na
        end
                                              
        //  ******Fecha******
                                  
        else if (Borde_F1_on)
        begin
        fig_RGB = 12'h00F;//Azul
        end
                                                                   
        else if (Borde_F2_on)
        begin
        fig_RGB = 12'h00F;//Azul
        end
                                                                       
        else if (Borde_F3_on)
        begin
        fig_RGB = 12'h00F;//Azul
        end
                                                                       
        else if (Borde_F4_on)
        begin
        fig_RGB = 12'h00F;//Azul
        end
        //  ******Timer******
                                                                      
        else if (Borde_T1_on)
        begin
        fig_RGB = 12'h4F0;//Verde
        end
                                                                                                       
        else if (Borde_T2_on)
        begin
        fig_RGB = 12'h4F0;//Verde
        end
                                                                                                           
        else if (Borde_T3_on)
        begin
        fig_RGB= 12'h4F0;//Verde
        end
                                                                                                           
        else if (Borde_T4_on)
        begin
        fig_RGB = 12'h4F0;//Verde
        end                               
                                   
        //*********Config**********
                           
        else if (Borde_C1_on)
        begin
        fig_RGB = 12'h0FF;//Cian
        end
                                      
                                 
        else if (Borde_C2_on)
        begin
        fig_RGB = 12'h0FF;//Cian
        end
                                      
        else if (Borde_C3_on)
        begin
        fig_RGB = 12'h0FF;//Cian
        end
                                       
        else if (Borde_C4_on)
        begin
        fig_RGB = 12'h0FF;//Cian
        end
end

assign graph_on = Borde_H1_on | Borde_H2_on | Borde_H3_on|Borde_H4_on|Borde_F1_on | Borde_F2_on | Borde_F3_on|Borde_F4_on|Borde_T1_on | Borde_T2_on | Borde_T3_on|Borde_T4_on|Borde_C1_on | Borde_C2_on | Borde_C3_on|Borde_C4_on; // Sin esta bandera no se puede pintar en el monitor los diferentes recuadros
	
endmodule
