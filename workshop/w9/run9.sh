#!/usr/bin/env bash

# compile
iverilog -o sim tb9.v ref9g.v flt.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
