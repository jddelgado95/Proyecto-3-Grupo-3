`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2017 11:59:34 PM
// Design Name: 
// Module Name: contadores_configuracion
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


module contadores_configuracion
(
input wire clk, 
input wire reset,
input wire [7:0] in_dato, port_id,
input wire write_strobe, k_write_strobe,
output wire [7:0] btn_data_SS, btn_data_MM, btn_data_HH, btn_data_YEAR, btn_data_MES, btn_data_DAY,
btn_data_SS_T, btn_data_MM_T, btn_data_HH_T,//Decenas y unidades para los números en pantalla(configuración)
output wire [1:0] cursor_location,//Marca la posición del cursor en modo configuración
output wire [1:0] config_mode
);

//Declaración de parámetros
localparam N = 2;//Bits del contador de desplazamiento horizontal

//Declaración de señales
reg [N-1:0] q_act, q_next;//Contador horizontal
wire [N-1:0] count_horizontal;

reg enLEFT_reg, enRIGHT_reg, enUP_reg, enDOWN_reg;
reg [1:0] reg_config_mode, next_config_mode;

reg [3:0]enable_counters;//9 contadores en total de hora, fecha, timer

//===========================================================================
// Registro para el modo de configuración
//===========================================================================
always@(posedge clk)
begin
	if(reset) reg_config_mode <= 2'b0;
	else reg_config_mode <= next_config_mode;
end
always@*
begin
	if((write_strobe == 1'b1 || k_write_strobe == 1'b1)&&(port_id == 8'h11)) next_config_mode = in_dato[4:3];
	else next_config_mode = reg_config_mode;
end

assign config_mode = reg_config_mode;
//===========================================================================
// Registro para generar el pulso de las teclas para modificar los contadores
//===========================================================================
always@(posedge clk)
begin
	if(write_strobe == 1'b1 || k_write_strobe == 1'b1)
	begin
		case(port_id)
		8'h11:
			begin
				if(in_dato[2] == 1'b1)
				begin
					case(in_dato[1:0])
					2'b00: enRIGHT_reg <= 1'b1;
					2'b01: enUP_reg <= 1'b1;
					2'b10: enDOWN_reg <= 1'b1;
					2'b11: enLEFT_reg <= 1'b1;
					endcase
				end
				else
				begin
					enRIGHT_reg <= 1'b0;
					enUP_reg <= 1'b0;
					enDOWN_reg <= 1'b0;
					enLEFT_reg <= 1'b0;
				end
			end
		default:
		begin
				enRIGHT_reg <= 1'b0;
				enUP_reg <= 1'b0;
				enDOWN_reg <= 1'b0;
				enLEFT_reg <= 1'b0;
		end
		endcase
	end
	else
	begin
		enRIGHT_reg <= 1'b0;
		enUP_reg <= 1'b0;
		enDOWN_reg <= 1'b0;
		enLEFT_reg <= 1'b0;
	end
end



//Contador horizontal
//Descripción del comportamiento
always@(posedge clk)
begin	
	
	if(reset)
	begin
		q_act <= 2'b0;
	end
	
	else
	begin
		q_act <= q_next;
	end
end

//Lógica de salida
always@*
begin
	if(enLEFT_reg)
	begin
	q_next = q_act + 1'b1;
	end
	
	else if(enRIGHT_reg)
	begin
	q_next = q_act - 1'b1;
	end
	
	else if(enLEFT_reg && q_act == 2 && config_mode == 1)
	begin
	q_next = 5'd0;
	end
	
	else if(enRIGHT_reg && q_act == 0 && config_mode == 1)
	begin
	q_next = 5'd2;
	end
	
	else if(enLEFT_reg && q_act == 2 && config_mode == 4)
	begin
	q_next = 5'd0;
	end
	
	else if(enRIGHT_reg && q_act == 0 && config_mode == 4)
	begin
	q_next = 5'd2;
	end	
	
	else
	begin
	q_next = q_act;
	end
end

assign count_horizontal = q_act;

//Instancias contadores de hora, fecha y timer

contador_AD_SS_2dig Instancia_contador_SS//Segundos de la hora
(
.clk(clk),
.reset(reset),
.en_count(enable_counters),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.data_SS(btn_data_SS)
);

contador_AD_MM_2dig Instancia_contador_MM//Minutos de la hora
(
.clk(clk),
.reset(reset),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.en_count(enable_counters),
.data_MM(btn_data_MM)
);

contador_AD_HH_2dig Instancia_contador_HH//Horas de la hora
(
.clk(clk), 
.reset(reset),
.en_count(enable_counters),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.data_HH(btn_data_HH)
);   

contador_AD_YEAR_2dig Instancia_contador_YEAR//Años de la fecha
(
.clk(clk),
.reset(reset),
.enUP(enUP_reg),
.en_count(enable_counters),
.enDOWN(enDOWN_reg),
.data_YEAR(btn_data_YEAR)
);

contador_AD_MES_2dig Instancia_contador_MES//Meses de la fecha
(
.clk(clk),
.reset(reset),
.en_count(enable_counters),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.data_MES(btn_data_MES)
);

contador_AD_DAY_2dig Instancia_contador_DAY//Día de la fecha
(
.clk(clk),
.reset(reset),
.en_count(enable_counters),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.data_DAY(btn_data_DAY)
);

contador_AD_SS_T_2dig Instancia_contador_SS_T//Segundos del timer
(
.clk(clk),
.reset(reset),
.en_count(enable_counters),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.data_SS_T(btn_data_SS_T)
);

contador_AD_MM_T_2dig Instancia_contador_MM_T//Minutos del timer
(
.clk(clk),
.reset(reset),
.en_count(enable_counters),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.data_MM_T(btn_data_MM_T)
);

contador_AD_HH_T_2dig Instancia_contador_HH_T //Horas del timer
(
.clk(clk),
.reset(reset),
.en_count(enable_counters),
.enUP(enUP_reg),
.enDOWN(enDOWN_reg),
.data_HH_T(btn_data_HH_T)
);

//Lógica de activación de cada contador dependiendo del modo configuración y la cuenta horizontal
always@*

	case(config_mode)//Evalúa que se está configurando (0: modo normal, 1: config.hora, 2: config.fecha, 3: config.timer)

	3'd0://Modo normal no habilita ningún contador
	begin
	enable_counters = 4'b0;
	end
	
	3'd1:
	begin
		case(count_horizontal)
		
		2'd0: enable_counters = 4'd1;//SS
		2'd1: enable_counters = 4'd2;//MM
		2'd2: enable_counters = 4'd3;//HH
		default: enable_counters = 4'd0;
	
		endcase
	end
	3'd2:
	begin
		case(count_horizontal)
		
		2'd0: enable_counters = 4'd4;//Año 
		2'd1: enable_counters = 4'd5;//Mes
		2'd2: enable_counters = 4'd6;//Día
		default: enable_counters = 4'd0;
		
		endcase
	end
	3'd3:
	begin
		case(count_horizontal)
		
		2'd0: enable_counters = 4'd8;//SS_T
		2'd1: enable_counters = 4'd9;//MM_T
		2'd2: enable_counters = 4'd10;//HH_T
		default: enable_counters = 4'd0;
		
		endcase
	end
	default: enable_counters = 4'b0;
	endcase

assign cursor_location = count_horizontal;
endmodule