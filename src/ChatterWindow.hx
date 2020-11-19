import js.lib.Function;
import core.Amaryllis;
import rm.core.Rectangle;
import Types.ChatterEvents;
import rm.windows.Window_Base;

using ChatterExtensions;

@:keep
@:native('ChatterWindow')
class ChatterWindow extends Window_Base {
  public var _shadowX: Float;
  public var _shadowY: Float;
  public var _shadowOpacity: Float;
  public var _fn: (ChatterWindow) -> Void;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
    this.setBackgroundType(Main.CHParams.backgroundType);
    this._shadowX = this.x;
    this._shadowY = this.y;
  }

  public function setupEvents(fn: (win: ChatterWindow) -> Void) {
    fn(this);
  }

  #if compileMV
  public override function drawTextEx(text: String, x: Float, y: Float): Float {
    var newWidth = this.textWidth(text) > this.contentsWidth() ? this.textWidth(text) : this.contentsWidth();
    this.move(this.x, this.y, newWidth, this.height);
    this.createContents();
    return super.drawTextEx(text, x, y);
  }
  #else
  public override function drawTextEx(text: String, x: Float, y: Float, width: Float): Float {
    // resize window and recreate contents.
    var newWidth = this.textWidth(text) > width ? this.textWidth(text) : width;
    this.move(this.x, this.y, newWidth, this.height);
    this.createContents();
    return super.drawTextEx(text, x, y, newWidth);
  }
  #end

  public function moveTo(x: Float, y: Float) {
    this._shadowX = x;
    this._shadowY = y;
  }

  public function moveBy(x: Float, ?y: Float) {
    this._shadowX += x;
    if (y != null) {
      this._shadowY += y;
    }
  }

  public function moveByWithFn(x: Float, ?y: Float, fn: (ChatterWindow) -> Void) {
    this._fn = fn;
    this.moveBy(x, y);
  }

  public function fadeTo(opacity: Float) {
    this._shadowOpacity = opacity;
  }

  public function fadeBy(opacity: Float) {
    this._shadowOpacity += opacity;
  }

  public function fadeToWithFn(opacity: Float, fn: (ChatterWindow) -> Void) {
    this._fn = fn;
    this.fadeTo(opacity);
  }

  public override function update() {
    super.update();
    switch (Main.CHParams.animationTypeNotification) {
      case FADE:
        this.updateFade();
      case SLIDE:
        this.updateMove();
    }
  }

  public function updateMove() {
    var xResult = this.x;
    var yResult = this.y;

    if (this._shadowX != this.x) {
      xResult = Amaryllis.lerp(this.x, this._shadowX, 0.025);
    }

    if (this._shadowY != this.y) {
      yResult = Amaryllis.lerp(this.y, this._shadowY, 0.025);
    }
    if (this._shadowX == this.x && this._shadowY == this.y) {
      // Disable Movement When matching
      // this._moveWait = -1;
      if (this._fn != null) {
        this._fn(this);
        this._fn = null;
      }
    }
    var xDiff = Math.abs(this._shadowX - this.x);
    var yDiff = Math.abs(this._shadowY - this.y);
    if (xDiff < 0.5) {
      xResult = Math.round(xResult);
    }

    if (yDiff < 0.5) {
      yResult = Math.round(yResult);
    }

    this.move(xResult, yResult, this.width, this.height);
  }

  public function updateFade() {
    ChatterExtensions.updateFade(this._shadowOpacity, cast this);
    if (this._shadowOpacity == this.opacity) {
      if (this._fn != null) {
        this._fn(this);
        this._fn = null;
      }
    }
  }

  public function paint() {
    if (this.contents != null) {
      this.contents.clear();
      this.emit(ChatterEvents.PAINT, this);
    }
  }

  public override function show() {
    this.emit(ChatterEvents.SHOW, this);
    super.show();
  }

  public override function hide() {
    this.emit(ChatterEvents.HIDE, this);
    super.hide();
  }

  public override function open() {
    this.emit(ChatterEvents.OPEN, this);
    super.open();
  }

  public override function close() {
    this.emit(ChatterEvents.CLOSE, this);
    super.close();
  }
}
