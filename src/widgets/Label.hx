package widgets;

import rm.core.Bitmap;
import rm.core.Sprite;

typedef LabelConfig = {
  var x: Float;
  var y: Float;
  var width: Float;
  var height: Float;

  /**
   * Background Color for  the label
   */
  var bgColor: String;

  var ?textColor: String;
  var text: String;
  var ?align: String;
}

@:keep
@:native('OxLabel')
@:expose('OxLabel')
class Label extends Sprite {
  public var bgColor: String;
  public var text: String;
  public var textColor: String;
  public var align: String;

  public function new(labelConfig: LabelConfig) {
    super();
    this.set(labelConfig);
    this.bitmap = new Bitmap(width, height);
  }

  public function set(config: LabelConfig) {
    this.x = config.x;
    this.y = config.y;
    this.width = config.width;
    this.height = config.height;
    this.text = config.text;
    this.bgColor = config.bgColor;
    this.textColor = config.textColor;
    this.align = config.align;
  }

  public function resize(width: Float, height: Float) {
    this.bitmap = new Bitmap(width, height);
  }

  override public function update() {
    super.update();
    this.updateText();
  }

  public function updateText() {
    var lineHeight = this.height - 2;
    if (this.width != this.bitmap.width || this.height != this.bitmap.height) {
      this.bitmap = new Bitmap(this.width, this.height);
      this.bitmap.updateTexture();
    }
    this.bitmap.clear();
    this.bitmap.fillRect(0, 0, this.width, this.height, this.bgColor);
    this.bitmap.textColor = this.textColor;
    this.bitmap.drawText(this.text, 0, 0, this.width, lineHeight, this.align);
  }
}
