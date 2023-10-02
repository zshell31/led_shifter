TOP := top_module
CURRENT_DIR := ${CURDIR}
SOURCE_DIR := ${CURRENT_DIR}/src
SOURCES := $(wildcard ${SOURCE_DIR}/*.rs)
VERILOG_DIR := ${CURRENT_DIR}/generated/verilog
VERILOG_SOURCES := ${VERILOG_DIR}/${TOP}.v
BOARD_BUILDDIR := ${CURRENT_DIR}/build

DEVICE := xc7z020_test
BITSTREAM_DEVICE := zynq7
PARTNAME := xc7z020clg400-1
OFL_BOARD := pynq_z2

XDC := ${CURRENT_DIR}/zynq7020_mini.xdc
XDC_CMD := -x ${XDC}

.DELETE_ON_ERROR:

.PHONY: all build synth flash clean clashi

${BOARD_BUILDDIR}:
	mkdir -p ${BOARD_BUILDDIR}

${VERILOG_SOURCES}: ${SOURCES}
	RUSTC_WRAPPER=../ferrum/target/debug/ferrum_compiler RUST_BACKTRACE=1 cargo build --lib

${BOARD_BUILDDIR}/${TOP}.eblif: ${VERILOG_SOURCES} ${XDC} | ${BOARD_BUILDDIR}
	cd ${BOARD_BUILDDIR} && symbiflow_synth -t ${TOP} -v ${VERILOG_SOURCES} -d ${BITSTREAM_DEVICE} -p ${PARTNAME} ${XDC_CMD}

${BOARD_BUILDDIR}/${TOP}.net: ${BOARD_BUILDDIR}/${TOP}.eblif
	cd ${BOARD_BUILDDIR} && symbiflow_pack -e ${TOP}.eblif -d ${DEVICE} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.place: ${BOARD_BUILDDIR}/${TOP}.net
	cd ${BOARD_BUILDDIR} && symbiflow_place -e ${TOP}.eblif -d ${DEVICE} -n ${TOP}.net -P ${PARTNAME} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.route: ${BOARD_BUILDDIR}/${TOP}.place
	cd ${BOARD_BUILDDIR} && symbiflow_route -e ${TOP}.eblif -d ${DEVICE} 2>&1 > /dev/null

${BOARD_BUILDDIR}/${TOP}.fasm: ${BOARD_BUILDDIR}/${TOP}.route
	cd ${BOARD_BUILDDIR} && symbiflow_write_fasm -e ${TOP}.eblif -d ${DEVICE}

${BOARD_BUILDDIR}/${TOP}.bit: ${BOARD_BUILDDIR}/${TOP}.fasm
	cd ${BOARD_BUILDDIR} && symbiflow_write_bitstream -d ${BITSTREAM_DEVICE} -f ${TOP}.fasm -p ${PARTNAME} -b ${TOP}.bit

build: ${VERILOG_SOURCES}

synth: ${BOARD_BUILDDIR}/${TOP}.bit

flash: ${BOARD_BUILDDIR}/${TOP}.bit
	#openFPGALoader -b ${OFL_BOARD} ${BOARD_BUILDDIR}/${TOP}.bit
	openocd -d -f /usr/share/openocd/scripts/interface/ftdi/digilent_jtag_smt2.cfg -f /usr/share/openocd/scripts/target/zynq_7000.cfg -c "init; pld load 0 ${BOARD_BUILDDIR}/${TOP}.bit; exit"

clean:
	rm -rf ${BUILDDIR}
