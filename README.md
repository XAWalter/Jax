# Jax
## Required Pkgs  
1. iverilog  
2. make  
3. gtkwave
4. yosys
4. nextpnr
5. icestrom


## Installation  
Script assumes Makefile template, and GoBoard constraints file are in the same directory. If this is not wanted  
`cat "$DIR"/goboard_Makefile_template >> "$project_name"/Makefile`
and
 `cat "$DIR"/Go_Board_Constraints.pcf >> "$project_name"/"$project_name"_constraints_top.pcf`
can be changed to the location of the Makefile template and constraints file

## Usage  
Once the script is called, there will be a prompt for the project name - which is the only required field, your name, and sid.  
After this the directory structure will be created with source, results, submodules, testbench, and turnin.

## Directories
#### testbench
The testbench directory is where the Makefile will look for the top module which must end in `_tb.v.`  
Multiple files may be in this directory, however the desired testbench must be the only file ending with `_tb.v`
#### source
The source directory is for all modules not including the testbench.  
#### results
The results directory will contain the output file that can be run with `vvp` as well as the `.vcd` file that can be viewed with `gtkwave`
#### submodules
Other verilog projects which were created using the script can be placed in this directory. `make` will compile `.v` files within the `source` directories of each of the submodules.
#### turnin
All files added to the turnin directory will be compressed when `make tin` is run,

## make commands
#### make
Running `make` while in the project directory will compile the source files and place the output file the `results` directory. Additionaly, this will set the dumpfile to `simx.vcd` in the `results` directory which can be viewed with `gtkwave`.

#### make sim
Running `make sim` while in the project directory will use `vvp` to run the compiled output file.

#### make view
Running `make view` while in the project directory will open the dump file with `gtkwave`.

#### make test
Running `make view` while in the project directory is similar to `make`, however the dumpfile will be set to `/dev/null` to avoid creating a `.vcd` file.

#### make synth
Running `make synth` while in the project directory will use yosys to attempt to synthesize the Verilog for the ice40 FPGA on the GoBoard

#### make par
Running `make par` while in the project directory will use nextpnr-ice40 to place and route on the ice40 FPGA

#### make pack 
Running `make par` while in the project directory will use icepack to create a bin file

#### make prog
Running `make par` while in the project directory will program the Goboard with the bin file
