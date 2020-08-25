PATHS 			:= source/
PATHR 			:= results/
PATHB 			:= submodules/
PATHT 			:= turnin/
PATHH 			:= testbench/

# Simulation	
OUTPUT 			:= $(PATHR)output
VC 				:= iverilog
SIM 			:= vvp
S_FLAGS 		:= -o 
DF_Macro 		:= DUMP_FILE_NAME
WF_viewer 		:= gtkwave

# Synthesis
SYNTH 			:= yosys
SY_FLAGS 		:= -p
SY_TARGET 		:= synth_ice40
SY_OUT_TYPE 	:= json
SY_OUTPUT 		:= $(PATHR)TOP.json

# Place and Route
PAR 			:= nextpnr
PAR_TARGET 		:= ice40
PAR_OPTS 		:= --hx1k --package vq100
CON_FLAG 		:= --pcf
PAR_OUT_TYPE	:= --asc
PAR_OUTPUT 		:= $(PATHR)TOP.asc

# BIN file
PACKER 			:= icepack
PACK_OUTPUT 	:= $(PATHR)TOP.bin

# Program
PROGRAMMER 		:= iceprog

# Files
NF 				:=/dev/null
DF 				:= $(PATHR)simx.vcd
README 			:= README.md

# Commands
GET 			:= cp
CLEAN 			:= rm
COMPRESS		:= tar
C_FLAGS 		:= -czvf
CF 				:= project.tar.gz

CONSTRAINT := $(wildcard ./*_top.pcf)
SOURCES := $(shell find ./ -path '*/$(PATHS)*' -type f)
TESTBENCH := $(wildcard $(PATHH)*_tb.v)

.PHONY: list clean

# Simulation
compile: $(SOURCES) $(TESTBENCH)
	$(VC) $(S_FLAGS) $(OUTPUT) -D '$(DF_Macro)="$(DF)"' $(TESTBENCH) $(SOURCES)

sim: $(OUTPUT)
	$(SIM) $(OUTPUT)

view: $(DF)
	$(WF_viewer) $(DF) &

test: $(SOURCES) $(TESTBENCH)
	$(VC) $(S_FLAGS) $(OUTPUT) -D '$(DF_Macro)="$(NF)"' $(TESTBENCH) $(SOURCES)

# Synth
synth: $(SOURCES)
	$(SYNTH) $(SY_FLAGS) "$(SY_TARGET) -$(SY_OUT_TYPE) $(SY_OUTPUT)" $(SOURCES)

# Place and Route
par: synth
	$(PAR)-$(PAR_TARGET) $(PAR_OPTS) $(CON_FLAG) $(CONSTRAINT) $(PAR_OUT_TYPE) $(PAR_OUTPUT) --$(SY_OUT_TYPE) $(SY_OUTPUT)


# Pack
pack: par
	$(PACKER) $(PAR_OUTPUT) $(PACK_OUTPUT)

# Program
prog: pack
	$(PROGRAMMER) $(PACK_OUTPUT)

# Compress
tin:
	$(GET) $(SOURCES) $(README) $(PATHT)
	$(COMPRESS) $(C_FLAGS) $(CF) $(PATHT)



$(OUTPUT): $(SOURCES) $(TESTBENCH)
	$(VC) $(S_FLAGS) $(OUTPUT) -D '$(DF_Macro)="$(DF)"' $(TESTBENCH) $(SOURCES)

$(DF): $(OUTPUT)
	$(SIM) $(OUTPUT)

clean:
	$(CLEAN) $(PATHR)*


list:
	$(info $(SOURCES))
