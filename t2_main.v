//---------------------------------
//--                             --
//--       D E F I N E S         --
//--                             --
//---------------------------------

`define ARMADO        2'b00
`define DESARMADO     2'b01
`define ACIONADO      2'b01
`define ATIVAR_ALARME 2'b11

//---------------------------------
//--                             --
//--         M O D U L E         --
//--                             --
//---------------------------------
module toplevel(
    input break,
    input hidden_sw,        
    input ignition,
    input door_driver,
    input door_pass,
    input reprogram,
    input clock,
    input reset,
    
    input [1:0] time_param_sel,
    input [3:0] time_value,

    output fuel_pump,
    output siren,
    output status
);

//---------------------------------
//--                             --
//--     R E G I S T E R S       --
//--                             --
//---------------------------------

reg [1:0] EA;       //Estado Atual
reg [1:0] PE;       //Próximo Estado

reg[1:0] interval;

reg start_timer;
wire fuel_wire;
wire expired;
wire one_hz_enable;

//---------------------------------
//--                             --
//--           D U T s           --
//--                             --
//---------------------------------

fuelPump DUT1 (.clock(clock), .reset(reset), .break(break), .hidden_sw(hidden_sw), .ignition(ignition), .fuel_pump(fuel_wire));

time_parameters DUT2( .clock(clock), .reset(reset), .time_param_sel(time_param_sel), .time_value(time_value),
.reprogram(reprogram), .interval(interval));

timer DUT3( .clock(clock), .reset(reset), .value(), .start_timer(start_timer), .expired(expired), .one_hz_enable(one_hz_enable));

//---------------------------------
//--                             --
//--        P R O C E S S        --
//--                             --
//---------------------------------

//Process para poder fazer a atualização dos estados
always @(posedge clock, posedge reset) begin
    if(reset) begin
        EA = `ARMADO;
    end else begin
        if(clock)
            EA = PE;
    end
end

//Para zerar valores indesejados
always @(posedge clock, posedge reset) begin
    if(reset) begin
        interval = 2'b0;
    end
end

//Para zerar valores indesejados
always @(posedge clock, posedge reset) begin
    if(EA == `ARMADO)
        interval = 2'b01;
        start_timer = 1'b1;
end

//---------------------------------
//--                             --
//--           F S M             --
//--                             --
//---------------------------------

//Process para a troca na FSM
always @* begin
    case(EA)
        `ARMADO:                    //Logica para sair de Armado para X ou Y
            PE = `ARMADO;
        `DESARMADO:                 //Logica para Desarmado voltar a Armado ou não
             PE = `ARMADO;       
        `ACIONADO:                  //Logica para Acionado avançar para ATIVAR_ALARME 
            PE = `ARMADO;
        `ATIVAR_ALARME:             //Logica pra avançar para ARMADO ou DESARMADO
             PE = `ARMADO;       
        
        default: PE = `ARMADO;
    endcase
end

//---------------------------------
//--                             --
//--       A S S I G N s         --
//--                             --
//---------------------------------
                
assign fuel_pump = fuel_wire;

endmodule