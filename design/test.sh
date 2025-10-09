#!/usr/bin/env bash

# compile
iverilog -o sim0 mux21.v mux21_tb.v

# actual simulation
vvp sim0

# waveform viewing
gtkwave mux21_tb.vcd
