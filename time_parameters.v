//---------------------------------
//--                             --
//--       D E F I N E S         --
//--                             --
//---------------------------------

`define T_ARM_DELAY       2'b00
`define T_DRIVER_DELAY    2'b01
`define T_PASSENGER_DELAY 2'b10
`define T_ALARM_ON        2'b11

//---------------------------------
//--                             --
//--         M O D U L E         --
//--                             --
//---------------------------------

module time_parameters(
    input clock,
    input reset,

    input [1:0]  time_param_sel,
    input [3:0]  time_value, 
    input        reprogram, 
    input [1:0]  interval,

    output [3:0] value
);

//---------------------------------
//--                             --
//--     R E G I S T E R S       --
//--                             --
//---------------------------------

reg [3:0] T_ARM_DELAY;              //Default: 0110 - 00
reg [3:0] T_DRIVER_DELAY;           //Default: 1000 - 01
reg [3:0] T_PASSENGER_DELAY;        //Default: 1111 - 10
reg [3:0] T_ALARM_ON;               //Default: 1010 - 11

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

always @(posedge clock, posedge reset) begin
    if(reset) begin
        T_ARM_DELAY       <= 4'b0110;
        T_DRIVER_DELAY    <= 4'b1000;
        T_PASSENGER_DELAY <= 4'b1111;
        T_ALARM_ON        <= 4'b1010;
    end
    else begin
        if(clock) begin
            if(reprogram) begin
                case(time_param_sel)
                    2'b00: T_ARM_DELAY       <= time_value;
                    2'b01: T_DRIVER_DELAY    <= time_value;
                    2'b10: T_PASSENGER_DELAY <= time_value;
                    2'b11: T_ALARM_ON        <= time_value;
                    default: T_ALARM_ON      <= time_value;
                endcase
            end
        end
    end
end

//---------------------------------
//--                             --
//--       A S S I G N s         --
//--                             --
//---------------------------------

assign value  =  (interval == `T_ARM_DELAY       )? T_ARM_DELAY      :
                 (interval == `T_DRIVER_DELAY    )? T_DRIVER_DELAY   :
                 (interval == `T_PASSENGER_DELAY)? T_PASSENGER_DELAY: 
                 (interval == `T_ALARM_ON       )? T_ALARM_ON : 4'b0000;


endmodule