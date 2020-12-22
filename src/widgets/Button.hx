package widgets;

import rm.core.Sprite;

typedef ButtonConfig = {
  var x: Float;
  var y: Float;
  var width: Float;
  var height: Float;
  var color: String;
  var onClick: () -> Void;
}

@:keep
@:native('OxButton')
@:expose('OxButton')
class Button extends Sprite {
  public var color: String;
  public var onClickFn: () -> Void;

  public function new(config: ButtonConfig) {
    super();
    this.set(config);
  }

  public function set(config: ButtonConfig) {
    this.x = config.x;
    this.y = config.y;
    this.width = config.width;
    this.height = config.height;
    this.color = config.color;
    this.onClickFn = config.onClick;
  }

  public function onClick() {
    this.onClickFn();
  }
}
