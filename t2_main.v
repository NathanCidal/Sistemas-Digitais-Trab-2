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




//---------------------------------
//--                             --
//--           D U T s           --
//--                             --
//---------------------------------





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

//---------------------------------
//--                             --
//--           F S M             --
//--                             --
//---------------------------------

//Process para a troca na FSM
always @* begin
    case(EA)
        `ARMADO:                    //Logica para sair de Armado para X ou Y
            
        `DESARMADO:                 //Logica para Desarmado voltar a Armado ou não

        `ACIONADO:                  //Logica para Acionado avançar para ATIVAR_ALARME 

        `ATIVAR_ALARME:             //Logica pra avançar para ARMADO ou DESARMADO
        
        
        default: EA = `ARMADO;
    endcase
end

//---------------------------------
//--                             --
//--       A S S I G N s         --
//--                             --
//---------------------------------
                


endmodule