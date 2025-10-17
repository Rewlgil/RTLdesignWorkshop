#!/usr/bin/env bash

# compile
iverilog -o sim tb1.v ref1g.v majority.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
