# ghdl.mk --- simulation using GHDL

# disable all built-in rules
.SUFFIXES:

# do not run in parallel
.NOTPARALLEL:

# === THESE SHOULD BE DEFINED IN A PROJECT ===

PROJECT		?= $(error PROJECT: variable not set)
VCDFORMAT	?= $(error VCDFORMAT: variable not set)

GHDL			?= ghdl 
GHDLSTD			?= $(error GHDLSTD: variable not set)
GHDLOPTIONS 	?=
GHDLSIMOPTIONS	?=

SRCS			?= $(error SRCS: variable not set)

# ===

TB_SRCS		= $(wildcard *_tb.vhd)
TESTBENCHES	= $(basename $(TB_SRCS))
TESTBENCH	?= $(firstword $(TESTBENCHES))

.DEFAULT_GOAL := all

.PHONY: all check clean help list tb vcd tb-% vcd-%

# cf is used to figure out the dependencies
# import does not analyze files, so it does not find all errors

$(PROJECT)-obj$(GHDLSTD).cf: $(SRCS)
	$(GHDL) import $(GHDLOPTIONS) --std=$(GHDLSTD) --work=$(PROJECT) $^

# make compiles (analyze, elaborate) everything needed to build the test bench X_tb

%_tb: %_tb.vhd $(PROJECT)-obj$(GHDLSTD).cf
	$(GHDL) import $(GHDLOPTIONS) --std=$(GHDLSTD) $<
	$(GHDL) make $(GHDLOPTIONS) --std=$(GHDLSTD) $@

## TESTBENCH below is a _tb executable that would be built by the rule above

GHWOPT_FILE	= $(wildcard $(TESTBENCH).ghwopt)

$(TESTBENCH).ghw: $(TESTBENCH)
	$(GHDL) run $(GHDLOPTIONS) $(TESTBENCH) --wave=$(TESTBENCH).ghw $(if $(GHWOPT_FILE), --read-wave-opt=$(GHWOPT_FILE)) $(GHDLSIMOPTIONS)

$(TESTBENCH).vcd: $(TESTBENCH)
	$(GHDL) run $(GHDLOPTIONS) $(TESTBENCH) --vcd=$(TESTBENCH).vcd $(GHDLSIMOPTIONS)

# PHONY TARGETS

# it is odd to build TESTBENCHES but without calling ghdl make
# entities are not analyzed so object files are not created, 
# which is required for users of this library
all: $(PROJECT)-obj$(GHDLSTD).cf $(TESTBENCHES)

# check runs tb-X targets, which in turn builds X tb and runs it
check:
	$(MAKE) $(addprefix tb-,$(TESTBENCHES))

list:
	@echo $(TESTBENCHES)

# build tb TESTBENCH and run it
tb: $(TESTBENCH)
	$(GHDL) run $(GHDLOPTIONS) $(TESTBENCH)

vcd: $(TESTBENCH).$(VCDFORMAT)
ifeq ($(VCDFORMAT),vcd)
	cat $(TESTBENCH).vcd | vcd
else ifeq ($(VCDFORMAT),ghw)
	gtkwave $(TESTBENCH).$(VCDFORMAT) $(wildcard $(TESTBENCH).gtkw)
endif

tb-%:
	TESTBENCH=$* $(MAKE) tb

vcd-%:
	TESTBENCH=$* $(MAKE) vcd

clean:
	rm -f *_tb
	rm -f *.ghw *.vcd
	rm -f *.o
	rm -f *.cf

help:
	@echo "Available targets:"
	@echo "	all         Compiles all sources."
	@echo "	check       Runs all test-benches."
	@echo "	clean       Cleans up any build artifacts."
	@echo "	help        Shows available targets."
	@echo "	list        List all test-benches."
	@echo "	tb          Runs the default ($(TESTBENCH)) test-bench."
	@echo "	vcd         Same as above, but starts a VCD viewer."
	@echo "	tb-TB       Runs the test-bench TB."
	@echo "	vcd-TB      Same as above, but starts a VCD viewer."

deps.mk: $(wildcard *.vhd)
	$(GHDL) --gen-makefile $(GHDLOPTIONS) *.vhd > deps.mk

# ghdl.mk ends here.
