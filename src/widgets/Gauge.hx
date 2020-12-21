package widgets;

import rm.core.Sprite;

typedef GaugeConfig = {
  var x: Float;
  var y: Float;
  var width: Float;
  var height: Float;
  var bgColor: String;
  var color: String;
  var rate: Float;
}

class Gauge extends Sprite {
  public var config: GaugeConfig;

  public function new(config: GaugeConfig) {
    super();
    this.config = config;
  }

  function get_color(): String {
    return this.config.color;
  }

  function set_color(color: String): String {
    this.config.color = color;

    return this.config.color;
  }

  function get_bgColor(): String {
    return this.config.bgColor;
  }

  function set_bgColor(color: String): String {
    this.config.bgColor = color;

    return this.config.bgColor;
  }
}
