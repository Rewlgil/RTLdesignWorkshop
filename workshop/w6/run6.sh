#!/usr/bin/env bash

# compile
iverilog -o sim tb6.v ref6g.v arb.v

# actual simulation
vvp sim

# waveform viewing
gtkwave sim.vcd
