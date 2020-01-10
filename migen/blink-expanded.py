#!/usr/bin/env python3
"""Simple tri-colour LED blink example."""

# Import lxbuildenv to integrate the deps/ directory
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
import lxbuildenv

from migen import *
from migen.build.generic_platform import *
import fomu

if 'FOMU_REV' not in os.environ:
    print('Board type must be specified in FOMU_REV environment variable!')
    exit(1)

#
# Parameters from iCE40 UltraPlus LED Driver Usage Guide, pages 19-20
#

# Current modes
RGBA_CURRENT_MODE_FULL = '0b0'
RGBA_CURRENT_MODE_HALF = '0b1'

# Current levels in Full / Half mode
RGBA_CURRENT_04MA_02MA = '0b000001'
RGBA_CURRENT_08MA_04MA = '0b000011'
RGBA_CURRENT_12MA_06MA = '0b000111'
RGBA_CURRENT_16MA_08MA = '0b001111'
RGBA_CURRENT_20MA_10MA = '0b011111'
RGBA_CURRENT_24MA_12MA = '0b111111'

# Type for input pins, from ICE Technology Library Manual, pages 87-90
SB_IO_TYPE_SIMPLE_INPUT = 0b000001

#
# Signals
#
counter = Signal(28)

rgb0_pwm = Signal(1)
rgb1_pwm = Signal(1)
rgb2_pwm = Signal(1)

input1 = Signal(1)
input2 = Signal(1)

# Setup platform and correctly map pins for the
# iCE40UP5K SB_RGBA_DRV hard macro.
if os.environ['FOMU_REV'] in ['evt1', 'evt2']:
    platform = fomu.FomuEvt2Platform()
    blue_pwm = rgb0_pwm
    red_pwm = rgb1_pwm
    green_pwm = rgb2_pwm
elif os.environ['FOMU_REV'] == 'evt3':
    platform = fomu.FomuEvt3Platform()
    blue_pwm = rgb0_pwm
    red_pwm = rgb1_pwm
    green_pwm = rgb2_pwm
elif os.environ['FOMU_REV'] == 'hacker':
    platform = fomu.FomuHackerPlatform()
    blue_pwm = rgb0_pwm
    green_pwm = rgb1_pwm
    red_pwm = rgb2_pwm
elif os.environ['FOMU_REV'] == 'pvt':
    platform = fomu.FomuPvtPlatform()
    green_pwm = rgb0_pwm
    red_pwm = rgb1_pwm
    blue_pwm = rgb2_pwm
else:
    print('Board not supported!')
    exit(2)

usb_pins = platform.request('usb')
rgb_pins = platform.request('rgb_led')

touch_pins = [platform.request('user_touch_n', i) for i in range(0, 4)]

m = Module()

###

# Drive the USB outputs to constant values as they are not in use.
# Assign USB pins to "0" so as to disconnect Fomu from
# the host system.  Otherwise it would try to talk to
# us over USB, which wouldn't work since we have no stack.
m.comb += [usb_pins.d_p.eq(0),
           usb_pins.d_n.eq(0),
           usb_pins.pullup.eq(0)]

# Use touch pins 1+2 to ground pulled-up inputs
m.comb += [touch_pins[1].eq(0),
           touch_pins[2].eq(0)]

# Wire inputs and clock divider to LEDs
m.comb += [red_pwm.eq(~input2),
           green_pwm.eq(counter[23]),
           blue_pwm.eq(~input1)]

# Increment counter on clock signal
m.sync += counter.eq(counter + 1)

# Instantiate iCE40 LED driver hard logic, connecting up
# latched button state, counter state, and LEDs.
#
# Note that it's possible to drive the LEDs directly,
# however that is not current-limited and results in
# overvolting the red LED.
#
# See also:
# https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/ICE40LEDDriverUsageGuide.ashx?document_id=50668
m.specials += Instance('SB_RGBA_DRV',
                       i_CURREN=0b1,
                       i_RGBLEDEN=0b1,
                       i_RGB0PWM=rgb0_pwm,
                       i_RGB1PWM=rgb1_pwm,
                       i_RGB2PWM=rgb2_pwm,
                       o_RGB0=rgb_pins.r,
                       o_RGB1=rgb_pins.g,
                       o_RGB2=rgb_pins.b,
                       p_CURRENT_MODE=RGBA_CURRENT_MODE_HALF,
                       p_RGB0_CURRENT=RGBA_CURRENT_08MA_04MA,
                       p_RGB1_CURRENT=RGBA_CURRENT_08MA_04MA,
                       p_RGB2_CURRENT=RGBA_CURRENT_08MA_04MA)

m.specials += Instance('SB_IO',
                       i_PACKAGE_PIN=touch_pins[0],
                       i_OUTPUT_ENABLE=0b0,
                       o_D_IN_0=input1,
                       p_PIN_TYPE=SB_IO_TYPE_SIMPLE_INPUT,
                       p_PULLUP=0b1)

m.specials += Instance('SB_IO',
                       i_PACKAGE_PIN=touch_pins[3],
                       i_OUTPUT_ENABLE=0b0,
                       o_D_IN_0=input2,
                       p_PIN_TYPE=SB_IO_TYPE_SIMPLE_INPUT,
                       p_PULLUP=0b1)

platform.build(m)
