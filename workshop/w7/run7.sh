#!/usr/bin/env bash

# compile
iverilog -o sim tb7.v ref7g.v remme.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
