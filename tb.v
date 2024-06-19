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

toplevel DUT (.clock(clock), .reset(reset), .break(break), .door_driver(door_driver), .door_pass(door_pass), .ignition(ignition), .hidden_sw(hidden_sw), .reprogram(reprogram),
            .time_param_sel(time_param_sel), .time_value(time_value));


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
    time_param_sel = 2'b0;
    time_value = 4'b0;

    hidden_sw = 0;
    ignition = 0;
    door_driver = 1;
    door_pass = 1;
    reprogram = 0;

    #PERIOD
    
    reset = 0;

    #(PERIOD*3)
    ignition = 1;

    #(PERIOD*3)
    break = 1;
    hidden_sw = 1;
end


endmodule