import chisel3._
import chisel3.experimental._
import chisel3.stage.ChiselStage
import firrtl.annotations.PresetAnnotation

class Blink(rev: String) extends RawModule {
  val clki = IO(Input(Clock()))

  val rgb0 = IO(Output(Bool()))
  val rgb1 = IO(Output(Bool()))
  val rgb2 = IO(Output(Bool()))

  val usb_dp = IO(Output(Bool()))
  val usb_dn = IO(Output(Bool()))
  val usb_dp_pu = IO(Output(Bool()))
  usb_dp := false.B
  usb_dn := false.B
  usb_dp_pu := false.B

  // initialize registers to their reset value when the bitstream is programmed since there is no reset wire
  val reset = IO(Input(AsyncReset()))
  annotate(new ChiselAnnotation {
    override def toFirrtl = PresetAnnotation(reset.toTarget)
  })

  // clock buffer
  val clk_gb = Module(new SB_GB)
  clk_gb.USER_SIGNAL_TO_GLOBAL_BUFFER := clki
  val clk = clk_gb.GLOBAL_BUFFER_OUTPUT

  // led driver
  val leds = Module(new SB_RGBA_DRV)
  leds.CURREN := true.B
  leds.RGBLEDEN := true.B
  rgb0 := leds.RGB0
  rgb1 := leds.RGB1
  rgb2 := leds.RGB2


  // Now that we have set up the clock and reset, we define a scope
  // in which all registers and modules will automatically use it.
  chisel3.withClockAndReset(clk, reset) {
    val (red, green, blue) = rev.toLowerCase match {
      case "hacker" => (leds.RGB2PWM, leds.RGB1PWM, leds.RGB0PWM)
      case "pvt" => (leds.RGB1PWM, leds.RGB0PWM, leds.RGB2PWM)
      case other => throw new RuntimeException(s"Unsupported device: $other")
    }

    val counter = RegInit(0.U(26.W))
    counter := counter + 1.U

    red := counter(24)
    green := counter(23)
    blue := counter(25)
  }
}

class SB_GB extends ExtModule {
  val USER_SIGNAL_TO_GLOBAL_BUFFER = IO(Input(Clock()))
  val GLOBAL_BUFFER_OUTPUT = IO(Output(Clock()))
}

class SB_RGBA_DRV extends ExtModule(Map(
  "CURRENT_MODE" -> "0b0",
  "RGB0_CURRENT" -> "0b000011",
  "RGB1_CURRENT" -> "0b000011",
  "RGB2_CURRENT" -> "0b000011",
)) {
  val CURREN = IO(Input(Bool()))
  val RGBLEDEN = IO(Input(Bool()))
  val RGB0PWM = IO(Input(Bool()))
  val RGB1PWM = IO(Input(Bool()))
  val RGB2PWM = IO(Input(Bool()))
  val RGB0 = IO(Output(Bool()))
  val RGB1 = IO(Output(Bool()))
  val RGB2 = IO(Output(Bool()))
}

// This main function reads in the version (pvt or hacker) and generates SystemVerilog from our Chisel design.
object VerilogGenerator extends App {
  val rev = args.headOption.getOrElse("pvt")
  (new ChiselStage).emitSystemVerilog(new Blink(rev))
}