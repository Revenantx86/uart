export DESIGN_NAME = uart
export PLATFORM    = sky130hd

export VERILOG_FILES = ./user_design/uart/src/uart.v \
					   ./user_design/uart/src/fifo.v

export SDC_FILE      = ./user_design/uart/constraint.sdc

export CORE_UTILIZATION = 45
#export CORE_ASPECT_RATIO = 1.5
#export FP_PDN_CORE_RING = 1

export TNS_END_PERCENT = 100

export PLACE_DENSITY ?= 0.80

# Power #
export PDN_TCL ?= ./user_design/uart/script/pdn.tcl