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
  }

  override public function update() {
    super.update();
    this.updateGauge();
  }

  public function updateGauge() {}
}
