package widgets;

import rm.core.Bitmap;
import rm.core.Sprite;

typedef PicConfig = {
  > UIElement,
  var bitmap: Bitmap;
}

class Pic extends Sprite {
  public function new(config: PicConfig) {
    super();
    this.set(config);
  }

  public function set(config: PicConfig) {
    this.x = config.x;
    this.y = config.y;
    this.width = config.width;
    this.height = config.height;
    this.bitmap = new Bitmap(this.width, this.height);
    this.setPic(config.bitmap);
  }

  public function setPic(bitmap: Bitmap) {
    bitmap.addLoadListener((newBitmap: Bitmap) -> {
      this.bitmap.clear();
      this.bitmap.blt(
        newBitmap,
        0,
        0,
        newBitmap.width,
        newBitmap.height,
        0,
        0,
        this.bitmap.width,
        this.bitmap.height
      );
    });
  }
}
