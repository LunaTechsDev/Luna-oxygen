package widgets;

import rm.core.Bitmap;
import pixi.core.graphics.Graphics;

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
class Panel extends Graphics {
  public var bgColor: String;

  public function new(config: PanelConfig) {
    super();
    this.set(config);
  }

  public function set(config: PanelConfig) {
    this.x = config.x;
    this.y = config.y;
    this.width = config.width;
    this.height = config.height;
    this.bgColor = config.bgColor;
    this.update();
  }

  public function update() {
    this.emit(UPDATE);
    this.updateChildren();
    this.updateBackground();
  }

  public function updateChildren() {
    for (child in this.children) {
      if (Fn.hasProperty(child, 'update')) {
        untyped child.update();
      }
    }
  }

  public function updateBackground() {
    var bm = new Bitmap();
    bm.context.fillStyle = this.bgColor;
    var color = bm.context.fillStyle.replace('#', '0x');
    this.fill = cast Fn.parseIntJs(color);
    this.beginFill();
    this.drawRect(0, 0, this.width, this.height);
    this.endFill();
  }
}
