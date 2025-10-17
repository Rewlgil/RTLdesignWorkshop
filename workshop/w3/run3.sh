#!/usr/bin/env bash

# compile
iverilog -o sim tb3.v ref3g.v signed_mag_compare.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
