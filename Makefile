
# single file
a%:
	iverilog -o $*.vvp $*.v
	vvp $*.vvp

# with stimulus
s%:
	iverilog $*.v stimulus.v
	vvp a.out

# show wave
# add `$dumpfile("XXXXX.vcd"); $dumpvars(0, stimulus);` in stimulus and create a new `a.out` first
w%:
	gtkwave $*.vcd &

# show diagram
# remember command `dot` can only render the first graph in .dot file
g%:
	yosys -p "read_verilog $*.v; synth; show; write_verilog $*.opt.v"
	dot -Tpng show.dot > show.png

.PHONY: clean
clean:
	del *.vcd
	del *.vvp
