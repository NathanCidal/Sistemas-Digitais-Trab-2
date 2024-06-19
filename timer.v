//---------------------------------
//--                             --
//--          N O T E S          --
//--                             --
//---------------------------------
//--    
//--    -> Segundo a implementação, temos um Clock de 100 MHz, ou seja,
//-- 1 segundo = 100.000.000 ciclos de Clock. Para fazer testes, será
//-- usado a lógica 1 segundo = 10 clicos de Clock <Por enquanto>
//--
//---------------------------------

//---------------------------------
//--                             --
//--       D E F I N E S         --
//--                             --
//---------------------------------

`define WAIT       1'b0 //Estado Inicial - Esperando o start_timer
`define WORKING    1'b1 //Estado Ciclo - Repetindo até chegar em zero 

//---------------------------------
//--                             --
//--         M O D U L E         --
//--                             --
//---------------------------------

module timer(
    input clock,
    input reset,

    input [3:0] value,          //Valor BIN que é equivalente a segundos
    input start_timer,

    output expired,             //Retorna para o sistema principal
    output one_hz_enable,       //Retorna para o sistema principal
    output half_hz_enable       //Utilizado na Sirene como Input
);

//---------------------------------
//--                             --
//--     R E G I S T E R S       --
//--                             --
//---------------------------------

// 15 Segundos -> 150 Clocks -> 128 = 2^7 ->     
// 3:0 = 4 Bits (15),
// 4:0 = 5 Bits (31) ,       5:0   = 6 Bits (63), 
// 6:0 = 7 Bits (127),       7:0   = 8 Bits (255)

reg [7:0] intCont;         // Contador Interno
reg [3:0] oneHzEnableCont; // Contador criado para contar quantos Hz podem ser ativados
reg EA, PE;          // Estado Atual - Proxime Estado

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

//Process padrão para a atualização da FSM
always @(posedge clock, posedge reset) begin
    if(reset) begin
        EA = `WAIT;
    end
    else if(clock) begin
        EA = PE;
    end
end

//Process de operações durante a minha FSM
always @(posedge clock, posedge reset) begin
    if(reset) begin
        intCont = 8'd0;
        oneHzEnableCont = value;
    end
    else if(clock) begin
        if(start_timer == 1'b1) begin
            intCont = value * 10;
            oneHzEnableCont = value;
        end

        if(EA == `WORKING) begin
            intCont = intCont - 8'b1;

            if(intCont % 8'd10 == 8'b0 && oneHzEnableCont != 4'b0) begin
             oneHzEnableCont = oneHzEnableCont - 4'b1; end
        end
    end
end

//FSM
always @* begin
    case(EA)
        `WAIT: begin
            if(start_timer == 1'b1) PE = `WORKING;
            else PE = `WAIT;
        end

        `WORKING: begin
            if(intCont != 8'b0) PE = `WORKING;
            else PE = `WAIT;
        end

        default: PE = `WAIT;
    endcase
end

//---------------------------------
//--                             --
//--       A S S I G N s         --
//--                             --
//---------------------------------

assign one_hz_enable =  (intCont % 8'd10 == 8'b0 && oneHzEnableCont != 4'b0 && EA == `WORKING)? 1'b1 : 1'b0;
assign half_hz_enable = (intCont % 8'd5 == 8'b0 && oneHzEnableCont != 4'b0 && EA == `WORKING)? 1'b1 : 1'b0;
assign expired =        (intCont == 8'b0 && oneHzEnableCont == 4'b0)?          1'b1 : 1'b0;


endmodule