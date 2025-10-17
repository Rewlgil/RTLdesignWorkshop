#!/usr/bin/env bash

# compile
iverilog -o sim tb4.v ref4g.v crossbar.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
