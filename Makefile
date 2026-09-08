IVERILOG ?= iverilog
VVP ?= vvp
.PHONY: sim clean
sim:
	mkdir -p build
	$(IVERILOG) -g2012 -Wall -s tb_alu32 -o build/alu_tb rtl/alu32.v tb/tb_alu32.v
	$(VVP) build/alu_tb
clean:
	rm -rf build
