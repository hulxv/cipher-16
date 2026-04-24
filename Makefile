# Flag to indicate wether we are in debug mode or not
DEBUG ?= 1
# Default max simulation time
SIMTIME ?= 1us


# VHDL compiler
GHDL = ghdl
# Wave simulator
ifeq ($(shell uname -s), Linux)
	WAVE = gtkwave
else
	# macOS support for gtkwave
	WAVE = open -a gtkwave
endif

# Source code directory
SRC = src
# Test bench directory
TB = tb
# Simulation file directory
SIMU = simu
# Directory containing all build files
BUILD = build

# Set error exit code according to the DEBUG flag
# Set maximum tolerance assertion level (errors will be triggered for this error type & above)
ifeq ($(DEBUG), 1)
	ERROREXIT = 0
	ASSERTLVL = error
else
	ERROREXIT = 1
	ASSERTLVL = warning
endif

# Source VHDL files
SOURCES = $(wildcard $(SRC)/*.vhdl)
TARGETS = $(patsubst $(SRC)/%.vhdl, %, $(SOURCES))
# Simulation files
SIMULATIONS = $(wildcard $(SIMU)/*.vcd)


all: builddir $(TARGETS)


# Dependencies
# <my entity>: <my other entity>


# IP with test bench
%: builddir $(SRC)/%.vhdl $(TB)/%_tb.vhdl
	@echo "\033[0;33m[Compiling \`$@.vhdl\` & \`$@_tb.vhdl\` ...]\033[0m"
	$(GHDL) -s --workdir=$(BUILD) $(SRC)/$@.vhdl $(TB)/$@_tb.vhdl
	$(GHDL) -a --workdir=$(BUILD) $(SRC)/$@.vhdl $(TB)/$@_tb.vhdl
	$(GHDL) -e --workdir=$(BUILD) -o $(BUILD)/$@_tb $@_tb

	@echo "\033[0;33m[Running simulation of \`$@_tb\` ...]\033[0m"
# Some versions of GHDL produce executables (in $(BUILD)/) and some do not, hence the first two parts of this command
	@./$(BUILD)/$@_tb --vcd=$(SIMU)/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME) 2> /dev/null || \
	$(GHDL) -r --workdir=$(BUILD) $@_tb --vcd=$(SIMU)/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME) && \
		echo "\033[0;32m[\`$@\` PASS]\033[0m" || (echo "\033[0;31m[\`$@\` FAIL]\033[0m"; exit $(ERROREXIT))


# IP without test bench
%: builddir $(SRC)/%.vhdl
	@echo "\033[0;33m[Compiling \`$@.vhdl\` ...]\033[0m"
	$(GHDL) -s --workdir=$(BUILD) $(SRC)/$@.vhdl
	$(GHDL) -a --workdir=$(BUILD) $(SRC)/$@.vhdl


builddir:
	@mkdir -p $(BUILD)/


simu:
	$(WAVE) $(SIMULATIONS)


clean:
	rm -rf $(BUILD)/ $(SIMU)/*.vcd


.PHONY: all builddir simu clean
