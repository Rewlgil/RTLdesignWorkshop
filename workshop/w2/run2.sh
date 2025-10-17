#!/usr/bin/env bash

# compile
iverilog -o sim tb2.v ref2g.v signed2twos.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
