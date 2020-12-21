package ext;

import rm.core.Bitmap;

class BitmapExt {
  /**
   * Draws lines to specified points
   * @param bitmap
   * @param strokeStyle Color of the stroke
   * @param x1
   * @param y1
   * @param x2
   * @param y2
   */
  public static function lineTo(bitmap: Bitmap, strokeStyle: String, x1: Float, y1: Float, x2: Float, y2: Float) {
    var context = bitmap.context;
    context.save();
    context.beginPath();
    context.moveTo(x1, y1);
    context.lineTo(x2, y2);
    context.strokeStyle = strokeStyle;
    context.stroke();
    context.restore();
    updateTexture(bitmap);
  }

  public static function strokeRect(bitmap: Bitmap, strokeStyle: String, x: Float, y: Float, width: Float,
      height: Float) {
    var context = bitmap.context;
    context.save();
    context.strokeStyle = strokeStyle;
    context.strokeRect(x, y, width, height);
    context.restore();
    updateTexture(bitmap);
  }

  public static function fillTriangle(bitmap: Bitmap, color: String, x1: Float, y1: Float, x2: Float, y2: Float,
      x3: Float, y3: Float) {
    var context = bitmap.context;
    context.save();
    context.beginPath();
    context.fillStyle = color;
    context.moveTo(x1, y2);
    context.lineTo(x2, y2);
    context.lineTo(x3, y3);
    context.fill();
  }

  public static function strokeTriangle(bitmap: Bitmap, strokeStyle: String, x1: Float, y1: Float, x2: Float,
      y2: Float, x3: Float, y3: Float) {
    var context = bitmap.context;
    context.save();
    context.beginPath();
    context.strokeStyle = strokeStyle;
    context.moveTo(x1, y2);
    context.lineTo(x2, y2);
    context.lineTo(x3, y3);
    context.stroke();
  }

  public static function strokeRndRect(bitmap: Bitmap, strokeStyle: String, x: Float, y: Float, width: Float,
      height: Float, radius: Float) {
    var ctx = bitmap.context;
    ctx.save();
    ctx.beginPath();
    ctx.strokeStyle = strokeStyle;
    ctx.moveTo(x, y + radius);
    ctx.lineTo(x, y + height - radius);
    ctx.arcTo(x, y + height, x + radius, y + height, radius);
    ctx.lineTo(x + width - radius, y + height);
    ctx.arcTo(x + width, y + height, x + width, y + height - radius, radius);
    ctx.lineTo(x + width, y + radius);
    ctx.arcTo(x + width, y, x + width - radius, y, radius);
    ctx.lineTo(x + radius, y);
    ctx.arcTo(x, y, x, y + radius, radius);
    ctx.stroke();
    ctx.restore();
  }

  public static function fillRndRect(bitmap: Bitmap, color: String, x: Float, y: Float, width: Float, height: Float,
      radius: Float) {
    var ctx = bitmap.context;
    ctx.save();
    ctx.beginPath();
    ctx.fillStyle = color;
    ctx.moveTo(x, y + radius);
    ctx.lineTo(x, y + height - radius);
    ctx.arcTo(x, y + height, x + radius, y + height, radius);
    ctx.lineTo(x + width - radius, y + height);
    ctx.arcTo(x + width, y + height, x + width, y + height - radius, radius);
    ctx.lineTo(x + width, y + radius);
    ctx.arcTo(x + width, y, x + width - radius, y, radius);
    ctx.lineTo(x + radius, y);
    ctx.arcTo(x, y, x, y + radius, radius);
    ctx.fill();
    ctx.restore();
  }

  public static inline function updateTexture(bitmap: Bitmap) {
    #if compileMV
    untyped bitmap._setDirty();
    #else
    // untyped to bypass
    untyped bitmap._baseTexture.update();
    #end
  }
}
