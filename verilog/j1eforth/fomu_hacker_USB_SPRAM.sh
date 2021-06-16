#!/bin/bash
rm build*

yosys -D HACKER=1 -p 'synth_ice40 -top top -json build.json' \
                        tinyfpga_bx_usbserial/usb/edge_detect.v \
                        tinyfpga_bx_usbserial/usb/serial.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_in_arb.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_in_pe.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_out_arb.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_out_pe.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_pe.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_rx.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_tx_mux.v \
                        tinyfpga_bx_usbserial/usb/usb_fs_tx.v\
                        tinyfpga_bx_usbserial/usb/usb_reset_det.v \
                        tinyfpga_bx_usbserial/usb/usb_serial_ctrl_ep.v \
                        tinyfpga_bx_usbserial/usb/usb_uart_bridge_ep.v \
                        tinyfpga_bx_usbserial/usb/usb_uart_core.v \
                        tinyfpga_bx_usbserial/usb/usb_uart_i40.v \
                        j1eforth.v 
                        
nextpnr-ice40 --up5k --freq 12 --opt-timing --package uwg30 --pcf pcf/fomu-hacker.pcf --json build.json --asc build.asc
icepack build.asc build.bit
icetime -d up5k -mtr build.rpt build.asc
cp build.bit build.dfu
dfu-suffix -v 1209 -p 70b1 -a build.dfu
