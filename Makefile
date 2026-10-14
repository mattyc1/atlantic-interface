# Atlantic FIFO bring-up (Verilator 5)
# Usage:
#   make sim     - build and run
#   make lint    - strict lint, no simulation
#   make waves   - open last VCD (gtkwave; use surfer if installed)
#   make clean

VERILATOR ?= verilator
TOP       ?= atlantic_if_tb
RTL       := rtl/atlantic_if.sv
TB        := tb/atlantic_if_tb.sv
SIM_DIR   := sim
VCD       := $(SIM_DIR)/$(TOP).vcd

COMMON_FLAGS := \
	--language 1800-2017 \
	-Wall \
	-Wno-DECLFILENAME \
	--top-module $(TOP) \
	--Mdir $(SIM_DIR) \
	$(RTL) $(TB)

.PHONY: all sim lint waves clean

all: sim

sim: $(SIM_DIR)/V$(TOP)
	./$(SIM_DIR)/V$(TOP)

$(SIM_DIR)/V$(TOP): $(RTL) $(TB)
	mkdir -p $(SIM_DIR)
	$(VERILATOR) --binary --timing --trace \
		--timescale 1ns/1ps \
		$(COMMON_FLAGS)

lint:
	$(VERILATOR) --lint-only $(COMMON_FLAGS)

waves:
	@if [ ! -f "$(VCD)" ]; then \
		echo "No VCD at $(VCD). Add \$dumpfile/\"$(VCD)\" and \$$dumpvars in the TB, then make sim."; \
		exit 1; \
	fi
	@if command -v surfer >/dev/null 2>&1; then \
		surfer $(VCD); \
	else \
		gtkwave $(VCD); \
	fi

clean:
	rm -rf $(SIM_DIR)
	rm -f *.vcd *.fst
