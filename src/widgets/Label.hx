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

  var text: String;
  var ?align: String;
}

class Label extends Sprite {
  public var config: LabelConfig;
  public var text(get, set): String;

  public function new(labelConfig: LabelConfig) {
    super();
    this.config = labelConfig;
    this.bitmap = new Bitmap(width, height);
  }

  public function resize(width: Float, height: Float) {
    this.bitmap = new Bitmap(width, height);
  }

  function get_text(): String {
    return this.config.text;
  }

  function set_text(text: String): String {
    this.config.text = text;
    var lineHeight = this.config.height - 2;
    this.bitmap.drawText(this.config.text, 0, 0, this.config.width, lineHeight, 'left');
    return this.config.text;
  }
}
