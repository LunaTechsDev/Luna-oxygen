package widgets;

import rm.core.Sprite;
import pixi.core.display.Container;
import rm.core.Bitmap;

typedef PanelConfig = {
  var x: Float;
  var y: Float;
  var width: Float;
  var height: Float;
  var bgColor: String;
};

@:keep
@:native('OxPanel')
@:expose('OxPanel')
class Panel extends Container {
  public var bgColor: String;
  public var background: Sprite;
  public var _width: Float;
  public var _height: Float;

  public function new(config: PanelConfig) {
    super();
    this.set(config);
  }

  public function set(config: PanelConfig) {
    this.x = config.x;
    this.y = config.y;
    this._width = config.width;
    this._height = config.height;
    this.bgColor = config.bgColor;
    trace(this.width, this._width, config.width);
    this.createBackground();
  }

  public function createBackground() {
    this.background = new Sprite();
    this.background.bitmap = new Bitmap(this._width, this._height);
    this.background.bitmap.fillAll(this.bgColor);
    this.addChild(this.background);
  }

  public function update() {
    this.emit(UPDATE);
    this.updateBackground();
    this.updateChildren();
  }

  public function updateChildren() {
    for (child in this.children) {
      if (untyped child.update != null) {
        untyped child.update();
      }
    }
  }

  public function updateBackground() {
    this.background.bitmap.clear();
    this.background.bitmap.fillAll(this.bgColor);
  }

  public function move(x: Float, ?y: Float) {
    this.x = x;
    if (y != null) {
      this.y = y;
    }
  }
}
