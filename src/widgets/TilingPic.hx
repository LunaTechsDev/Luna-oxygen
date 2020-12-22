package widgets;

import rm.core.TilingSprite;
import rm.core.Bitmap;
import widgets.Pic.PicConfig;

typedef TilingPicConfig = {
  > PicConfig,
  var scrollX: Float;
  var scrollY: Float;
};

class TilingPic extends Pic {
  public var tilingSprite: TilingSprite;
  public var scrollX: Float;
  public var scrollY: Float;

  public function new(config: TilingPicConfig) {
    super(config);
  }

  override public function set(config: PicConfig) {
    var tpConfig: TilingPicConfig = cast config;
    this.scrollX = tpConfig.scrollX;
    this.scrollY = tpConfig.scrollY;
    super.set(config);
  }

  override public function setPic(bitmap: Bitmap) {
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
      this.tilingSprite = new TilingSprite(this.bitmap);
      this.tilingSprite.move(0, 0, this.width, this.height);
      this.addChild(this.tilingSprite);
    });
  }

  override public function update() {
    super.update();
    this.updateTiling();
  }

  public function updateTiling() {
    this.tilingSprite.origin.x += this.scrollX;
    this.tilingSprite.origin.y += this.scrollY;
  }
}
