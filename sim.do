quit -sim
if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vlog -work work t2_main.v
vlog -work work tb.v
vlog -work work time_parameters.v
vlog -work work timer.v
vlog -work work fuelpump.v

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 

run 1 us