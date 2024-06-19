onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Clock/Reset
add wave -noupdate -radix binary /tb/DUT/clock
add wave -noupdate -radix binary /tb/DUT/reset
add wave -noupdate -divider FSM
add wave -noupdate -radix binary /tb/DUT/EA
add wave -noupdate -radix binary /tb/DUT/PE
add wave -noupdate -divider {Inputs (Top)}
add wave -noupdate -radix binary /tb/DUT/break
add wave -noupdate -radix binary /tb/DUT/hidden_sw
add wave -noupdate -radix binary /tb/DUT/ignition
add wave -noupdate -radix binary /tb/DUT/door_driver
add wave -noupdate -radix binary /tb/DUT/door_pass
add wave -noupdate -radix binary /tb/DUT/reprogram
add wave -noupdate /tb/DUT/time_param_sel
add wave -noupdate /tb/DUT/time_value
add wave -noupdate -divider {Outputs (Top)}
add wave -noupdate -radix binary /tb/DUT/fuel_pump
add wave -noupdate -radix binary /tb/DUT/siren
add wave -noupdate -radix binary /tb/DUT/status
add wave -noupdate -divider Timer
add wave -noupdate /tb/DUT/DUT3/value
add wave -noupdate /tb/DUT/DUT3/start_timer
add wave -noupdate /tb/DUT/DUT3/expired
add wave -noupdate /tb/DUT/DUT3/one_hz_enable
add wave -noupdate /tb/DUT/DUT3/EA
add wave -noupdate /tb/DUT/DUT3/PE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {144 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {50 ns} {1050 ns}
