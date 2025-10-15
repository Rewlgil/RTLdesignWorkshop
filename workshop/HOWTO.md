## how to run and simulate the workshop files

1. make you you have `git` `iverilog` `zip` and `gtkwave` working in your environment
2. download `workshops.zip` and unzip it to your desired folder.
3. run `chmod +x chmod_all.sh` to make set execution permissions.
4. run `./chmod_all.sh` -- this will allow all small scripts in every workshop to run.
5. in a workshop, like `w6`, you can type `./run6.sh` and it will
   - compile source verilog for you
   - run simulation with verification, giving you `PASSED` or `ERROR` feedback.
   - dump all the data, so you can view where your design has error (if any) using `gtkwave`
