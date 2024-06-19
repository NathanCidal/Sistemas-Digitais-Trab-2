//---------------------------------
//--                             --
//--       D E F I N E S         --
//--                             --
//---------------------------------

`define DESLIGADO   2'b00
`define IGNITION    2'b01
`define LIGADO      2'b10

//---------------------------------
//--                             --
//--         M O D U L E         --
//--                             --
//---------------------------------
module fuelPump(
    input clock,
    input reset,

    input break,
    input hidden_sw,
    input ignition,
    output fuel_pump
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
        EA = `DESLIGADO;
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

//Maquina de Estado para alteração de estado
//Ignition = 0 -> Desligado
//Liga Ignition -> Verifica agora se o pedal e o hidden_switch tá ligado
//Break ^ Hidden -> Ligado enquanto Ignition = 1

always @* begin
    case(EA)
        `DESLIGADO: if(ignition == 1'b1) PE = `IGNITION; else PE = `DESLIGADO;
        `IGNITION:  
            if(ignition == 1'b0) 
                PE = `DESLIGADO; 
            else begin
                if(break == 1'b1 && hidden_sw == 1'b1)
                    PE = `LIGADO;
                else 
                    PE = `IGNITION;
            end

        `LIGADO:  if(ignition == 1'b1) PE = `LIGADO; else PE = `DESLIGADO;
        default: PE = `DESLIGADO;
    endcase
end

//---------------------------------
//--                             --
//--       A S S I G N s         --
//--                             --
//---------------------------------

assign fuel_pump = (EA == `LIGADO)? 1'b1 : 1'b0;
            
endmodule