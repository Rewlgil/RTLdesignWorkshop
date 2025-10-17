#!/usr/bin/env bash

# compile
iverilog -o sim tb8.v ref8g.v vend.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
