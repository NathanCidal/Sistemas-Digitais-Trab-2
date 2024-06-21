//---------------------------------
//--                             --
//--       D E F I N E S         --
//--                             --
//---------------------------------

`define ARMADO        2'b00
`define DESARMADO     2'b01
`define ACIONADO      2'b01
`define ATIVAR_ALARME 2'b11

`define DISARM_DISABLE    3'b000
`define DISARM_WAIT_IGN   3'b001
`define DISARM_OPEN_DOOR  3'b010
`define DISARM_CLOSE_DOOR 3'b011
`define DISARM_WAIT_DELAY 3'b100
`define DISARM_DONE       3'b101

`define DOOR_CLOSED       2'b00;
`define DOOR_OPEN         2'b01;
`define DOOR_CLOSED_AGAIN 2'b10;

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

reg [2:0] D_EA;     //Estado Atual do Disarm
reg [2:0] D_PE;     //Próximo Estado do Disarm

reg[1:0] EA_DD;     //Estado Atual Motorista
reg[1:0] PE_DD;     //Proximo Estado Motorista

reg[1:0] EA_DP;     //Estado Atual   Passageiro
reg[1:0] PE_DP;     //Proximo Estado Passageiro


reg driverInside;       //Detecta Motorista
reg passagerInside;     //Detecta Passageiro

reg[1:0] interval;

reg start_timer;
wire fuel_wire;
wire expired;
wire one_hz_enable;

wire [3:0] valueWire;

//---------------------------------
//--                             --
//--           D U T s           --
//--                             --
//---------------------------------

fuelPump DUT1 (.clock(clock), .reset(reset), .break(break), .hidden_sw(hidden_sw), .ignition(ignition), .fuel_pump(fuel_wire));

time_parameters DUT2( .clock(clock), .reset(reset), .time_param_sel(time_param_sel), .time_value(time_value),
.reprogram(reprogram), .interval(interval), .value(valueWire));

timer DUT3( .clock(), .reset(reset), .value(valueWire), .start_timer(start_timer), .expired(expired), .one_hz_enable(), .half_hz_enable());

//---------------------------------
//--                             --
//--        P R O C E S S        --
//--                             --
//---------------------------------

//Process para poder fazer a atualização dos estados
always @(posedge clock, posedge reset) begin
    if(reset) begin
        EA = `ARMADO;
        D_EA = `DISARM_DISABLE;
        EA_DD = `DOOR_CLOSED;
        EA_DP = `DOOR_CLOSED;
    end
    else begin
            EA = PE;
            D_EA = D_PE;
            EA_DD = PE_DD;
            EA_DP = PE_DP;
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

/*
Armado: O indicador de status deve piscar com um periodo de dois segundos; a sirene está
desligada. Se a chave de ignição for ligada, passe para o modo Desarmado, caso contrario, quando
uma porta for aberta, inicie a contagem regressiva apropriada e vá para o modo Acionado. Este  é
o estado que a FSM deve ter quando o sistema é ligado.

•Acionado: A luz indicadora de status deve ficar constantemente acesa; a sirene está desligada. Se
a chave de ignição for ligada, vá para o modo Desarmado. Se a contagem regressiva expirar antes
de a ignição ser ligada, vá para o modo de Ativar Alarme.

•Ativar Alarme: A luz indicadora de status e a sirene devem ficar constantemente ligadas. O
alarme deve continuar até que T_ALARM ON segundos ap ́os todas as portas estarem fechadas (neste
ponto, vá para o modo Armado) ou a chave de ignição seja ligada (neste ponto, vá para o modo
Desarmado).

•Desarmado: A luz indicadora de status e sirene devem estar desligadas. Aguarde até que a chave
de ignição seja desligada, seguida pela abertura e fechamento da porta do motorista, depois de
T_ARM DELAY segundos, vá para o modo Armado
*/



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



//Process para a troca da FSM do Desarmado


//------------------------------------------------------------------------------------------------------------------------
//
//      DESARM STATE
//
//------------------------------------------------------------------------------------------------------------------------

/*
`define DISARM_DISABLE    3'b000
`define DISARM_WAIT_IGN   3'b001
`define DISARM_OPEN_DOOR  3'b010
`define DISARM_CLOSE_DOOR 3'b011
`define DISARM_WAIT_DELAY 3'b100
`define DISARM_DONE       3'b101
*/



//Codificação do Estado do DESARMADO
/*
    DOOR 0 = FECHADO
    DOOR 1 = ABERTO

    IF(EA == `DESARMADO) then
        status and siren = off;

    ignition = off -> abrir porta do motorista -> fechar porta do motorista -> T_ARM_DELAY -> Armado

    •Desarmado: A luz indicadora de status e sirene devem estar desligadas. Aguarde até que a chave
    de ignição seja desligada, seguida pela abertura e fechamento da porta do motorista, depois de
    T_ARM DELAY segundos, vá para o modo Armado
*/

always @* begin
    case(D_EA)
        `DISARM_DISABLE:

        `DISARM_WAIT_IGN:

        `DISARM_OPEN_DOOR:  //Espera tanto o motorista quanto o passageiro não estarem no carro

        `DISARM_WAIT_DELAY:

        `DISARM_DONE:

        default: D_PE = `DISARM_DISABLE;
    endcase
end


//------------------------------------------------------------------------------------------------------------------------
//
//      PASSAGER AND DRIVER DETECTOR
//
//------------------------------------------------------------------------------------------------------------------------

always@* begin
    case(EA_DD)
        `DOOR_CLOSED:  if(door_driver == 1'b1) PE_DD = `DOOR_OPEN; else PE_DD = `DOOR_CLOSED;
        `DOOR_OPEN:    if(door_driver == 1'b0) PE_DD = `DOOR_CLOSED; else PE_DD = `DOOR_CLOSED;
        `DOOR_CLOSED_AGAIN: PE_DD = `DOOR_CLOSED;
        default: PE_DD = `DOOR_CLOSED;
    endcase

    case(EA_DP)
        `DOOR_CLOSED:  if(door_pass == 1'b1) PE_DP = `DOOR_OPEN; else PE_DP = `DOOR_CLOSED;
        `DOOR_OPEN:    if(door_pass == 1'b0) PE_DP = `DOOR_CLOSED; else PE_DP = `DOOR_CLOSED;
        `DOOR_CLOSED_AGAIN: PE_DP = `DOOR_CLOSED;
        default: PE_DP = `DOOR_CLOSED;
    endcase
end

always @(posedge clock, posedge reset) begin
    if(reset) begin 
        driverInside <= 1'b0;
        passagerInside <= 1'b0;
    end
    else begin

    if(EA_DD = `DOOR_CLOSED_AGAIN)
        driverInside = ~driverInside;

    if(EA_DP = `DOOR_CLOSED_AGAIN)
        passagerInside = ~passagerInside;

    end
end

//------------------------------------------------------------------------------------------------------------------------


//---------------------------------
//--                             --
//--       A S S I G N s         --
//--                             --
//---------------------------------
                
assign fuel_pump = fuel_wire;

endmodule