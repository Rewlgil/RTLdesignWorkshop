yosys -p '
  read_verilog w1/ref1.v
  prep -top ref1        # make top-level signals visible
  flatten              # remove hierarchy (optional for obfuscation)
  proc; opt            # simplify processes
  memory; opt          # convert memories
  techmap; opt         # map complex ops to basic cells
  write_verilog -noattr w1/ref1g.v
'

yosys -p '
  read_verilog w2/ref2.v
  prep -top ref2        # make top-level signals visible
  flatten              # remove hierarchy (optional for obfuscation)
  proc; opt            # simplify processes
  memory; opt          # convert memories
  techmap; opt         # map complex ops to basic cells
  write_verilog -noattr w2/ref2g.v
'

yosys -p '
  read_verilog w3/ref3.v
  prep -top ref3        # make top-level signals visible
  flatten              # remove hierarchy (optional for obfuscation)
  proc; opt            # simplify processes
  memory; opt          # convert memories
  techmap; opt         # map complex ops to basic cells
  write_verilog -noattr w3/ref3g.v
'

yosys -p '
  read_verilog w4/ref4.v
  prep -top ref4        # make top-level signals visible
  flatten              # remove hierarchy (optional for obfuscation)
  proc; opt            # simplify processes
  memory; opt          # convert memories
  techmap; opt         # map complex ops to basic cells
  write_verilog -noattr w4/ref4g.v
'
