package widgets;

import rm.core.Bitmap;
import rm.core.Sprite;

typedef GaugeConfig = {
  var x: Float;
  var y: Float;
  var width: Float;
  var height: Float;
  var bgColor: String;
  var color: String;
  var rate: Float;
  var leftStyle: GaugeStyle;
  var rightStyle: GaugeStyle;
}

@:keep
@:native('OxGauge')
@:expose('OxGauge')
class Gauge extends Sprite {
  public var bgColor: String;
  public var color: String;
  public var rate: Float;
  public var leftStyle: GaugeStyle;
  public var rightStyle: GaugeStyle;

  public function new(config: GaugeConfig) {
    super();
    this.set(config);
    this.bitmap = new Bitmap(this.width, this.height);
  }

  public function set(config: GaugeConfig) {
    this.x = config.x;
    this.y = config.y;
    this.width = config.width;
    this.height = config.height;
    this.rate = config.rate;
    this.bgColor = config.bgColor;
    this.color = config.color;
    this.leftStyle = config.leftStyle;
    this.rightStyle = config.rightStyle;
  }

  override public function update() {
    super.update();
    this.updateGauge();
  }

  public function updateGauge() {
    this.bitmap.clear();
    this.paintGauge();
  }

  public function paintGauge() {
    var ctx = this.bitmap.context;
    ctx.save();
    ctx.beginPath();
    switch (this.leftStyle) {
      case LBOX:
        // Start from Bottom Left
        ctx.moveTo(0, this.height);
        ctx.lineTo(0, 0);
      case LARROW:
        ctx.moveTo(this.height / 2, this.height);
        ctx.lineTo(0, this.height / 2);
        ctx.lineTo(this.height / 2, 0);
      // Do nothing
      case LSLANT:
        ctx.moveTo(this.height / 2, this.height);
        ctx.lineTo(0, this.height);
      case RSLANT:
        ctx.moveTo(0, this.height);
        ctx.lineTo(this.height / 2, this.height);
      case _:
        // Do nothing
    }

    // Mid Section

    switch (this.rightStyle) {
      case RBOX:
        // Do nothing
        ctx.lineTo(this.width, 0);
        ctx.lineTo(this.width, this.height);

      // Close Shape

      case RARROW:
        ctx.lineTo(this.width - (this.height / 2), 0);
        ctx.lineTo(this.width, this.height / 2);
        ctx.lineTo(this.width - (this.height / 2), this.height);
      // Do nothing
      case RSLANT:
        ctx.lineTo(this.width, 0);
        ctx.lineTo(this.width - (this.height / 2), this.height);
      case LSLANT:
        ctx.lineTo(this.width - (this.height / 2), 0);
        ctx.lineTo(this.width, this.height);

      case _:
        // Do nothing
    }
    ctx.closePath();
    ctx.fillStyle = this.color;
    ctx.fill();
    this.bitmap.updateTexture();
    ctx.restore();
  }
}
