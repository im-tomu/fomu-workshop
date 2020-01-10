""" Fomu board definitions (mapping of I/O pins, clock, etc.) """

from migen import *
from migen.build.generic_platform import *
from migen.build.lattice import LatticePlatform


class FomuPvtPlatform(LatticePlatform):
    """ Based on
        https://github.com/litex-hub/litex-boards/blob/master/litex_boards/partner/platforms/fomu_pvt.py """

    _io = [
        ('clk48', 0, Pins('F4'), IOStandard('LVCMOS33')),

        ('user_led_n', 0, Pins('A5'), IOStandard('LVCMOS33')),
        ('rgb_led', 0,
            Subsignal('r', Pins('C5')),
            Subsignal('g', Pins('B5')),
            Subsignal('b', Pins('A5')),
            IOStandard('LVCMOS33')),

        ('user_touch_n', 0, Pins('E4'), IOStandard('LVCMOS33')),
        ('user_touch_n', 1, Pins('D5'), IOStandard('LVCMOS33')),
        ('user_touch_n', 2, Pins('E5'), IOStandard('LVCMOS33')),
        ('user_touch_n', 3, Pins('F5'), IOStandard('LVCMOS33')),

        ('usb', 0,
            Subsignal('d_p', Pins('A1')),
            Subsignal('d_n', Pins('A2')),
            Subsignal('pullup', Pins('A4')),
            IOStandard('LVCMOS33'))
    ]

    _connectors = [
        ('touch_pins', 'E4 D5 E5 F5')
    ]

    default_clk_name = 'clk48'
    default_clk_period = 1e9 / 48e6

    def __init__(self):
        LatticePlatform.__init__(self,
                                 'ice40-up5k-uwg30',
                                 self._io,
                                 self._connectors,
                                 toolchain='icestorm')

    def create_programmer(self):
        return IceStormProgrammer()


class FomuHackerPlatform(LatticePlatform):
    """ Based on
        https://github.com/litex-hub/litex-boards/blob/master/litex_boards/partner/platforms/fomu_hacker.py """

    _io = [
        ('clk48', 0, Pins('F5'), IOStandard('LVCMOS33')),

        ('user_led_n', 0, Pins('A5'), IOStandard('LVCMOS33')),
        ('rgb_led', 0,
            Subsignal('r', Pins('C5')),
            Subsignal('g', Pins('B5')),
            Subsignal('b', Pins('A5')),
            IOStandard('LVCMOS33')),

        ('user_touch_n', 0, Pins('F4'), IOStandard('LVCMOS33')),
        ('user_touch_n', 1, Pins('E5'), IOStandard('LVCMOS33')),
        ('user_touch_n', 2, Pins('E4'), IOStandard('LVCMOS33')),
        ('user_touch_n', 3, Pins('F2'), IOStandard('LVCMOS33')),

        ('usb', 0,
            Subsignal('d_p', Pins('A4')),
            Subsignal('d_n', Pins('A2')),
            Subsignal('pullup', Pins('D5')),
            IOStandard('LVCMOS33'))
    ]

    _connectors = [
        ('touch_pins', 'F4 E5 E4 F2')
    ]

    default_clk_name = 'clk48'
    default_clk_period = 1e9 / 48e6

    def __init__(self):
        LatticePlatform.__init__(self,
                                 'ice40-up5k-uwg30',
                                 self._io,
                                 self._connectors,
                                 toolchain='icestorm')

    def create_programmer(self):
        return IceStormProgrammer()


class FomuEvt2Platform(LatticePlatform):
    """ Based on
        https://github.com/litex-hub/litex-boards/blob/master/litex_boards/partner/platforms/fomu_evt.py """

    _io = [
        ('clk48', 0, Pins('44'), IOStandard('LVCMOS33')),

        ('user_led_n', 0, Pins('41'), IOStandard('LVCMOS33')),
        ('rgb_led', 0,
            Subsignal('r', Pins('40')),
            Subsignal('g', Pins('39')),
            Subsignal('b', Pins('41')),
            IOStandard('LVCMOS33')),

        ('user_touch_n', 0, Pins('48'), IOStandard('LVCMOS33')),
        ('user_touch_n', 1, Pins('47'), IOStandard('LVCMOS33')),
        ('user_touch_n', 2, Pins('46'), IOStandard('LVCMOS33')),
        ('user_touch_n', 3, Pins('45'), IOStandard('LVCMOS33')),

        ('usb', 0,
            Subsignal('d_p', Pins('34')),
            Subsignal('d_n', Pins('37')),
            Subsignal('pullup', Pins('35')),
            Subsignal('pulldown', Pins('36')),
            IOStandard('LVCMOS33'))
    ]

    _connectors = [
        ('touch_pins', '48 47 46 45')
    ]

    default_clk_name = 'clk48'
    default_clk_period = 1e9 / 48e6

    def __init__(self):
        LatticePlatform.__init__(self,
                                 'ice40-up5k-sg48',
                                 self._io,
                                 self._connectors,
                                 toolchain='icestorm')

    def create_programmer(self):
        return IceStormProgrammer()


FomuEvt3Platform = FomuEvt2Platform
