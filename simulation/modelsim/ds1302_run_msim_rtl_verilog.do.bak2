transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/verilog\ practice/ds1302 {F:/verilog practice/ds1302/spi.v}

vlog -vlog01compat -work work +incdir+F:/verilog\ practice/ds1302/simulation/modelsim {F:/verilog practice/ds1302/simulation/modelsim/spi.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  spi_vlg_tst

add wave *
view structure
view signals
run 100 ps
