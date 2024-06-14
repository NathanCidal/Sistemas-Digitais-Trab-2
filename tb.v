//---------------------------------
//--                             --
//--       D E F I N E S         --
//--                             --
//---------------------------------

`timescale 1ns/1ps         

//---------------------------------
//--                             --
//--         M O D U L E         --
//--                             --
//---------------------------------

module tb( );

//---------------------------------
//--                             --
//--     R E G I S T E R S       --
//--                             --
//---------------------------------

reg break, hidden_sw, ignition, door_driver;
reg door_pass, reprogram, clock, reset;

reg [1:0] time_param_sel;
reg [3:0] time_value;

//---------------------------------
//--                             --
//--           D U T s           --
//--                             --
//---------------------------------


//---------------------------------
//--    P A R A M E T E R S      --
//---------------------------------
localparam PERIOD = 10;

//Make Clock goes forever "0 -> 1", "1 -> 0", "0 -> 1"...
initial begin
    clock = 0;
    forever #(PERIOD/2) clock = ~clock;
end

initial begin
    reset = 1;
    break = 0;

    hidden_sw = 0;
    ignition = 0;
    door_driver = 1;
    door_pass = 1;
    reprogram = 0;

    #PERIOD
    
    reset = 0;
end


endmodule