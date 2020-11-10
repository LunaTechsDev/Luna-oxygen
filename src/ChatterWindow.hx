import core.Amaryllis;
import rm.core.Rectangle;
import Types.ChatterEvents;
import rm.windows.Window_Base;

@:keep
@:native('ChatterWindow')
class ChatterWindow extends Window_Base {
  public var _shadowX: Float;
  public var _shadowY: Float;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
    this.setBGType();
    this._shadowX = this.x;
    this._shadowY = this.y;
  }

  public function setBGType() {
    this.setBackgroundType(Main.CHParams.backgroundType);
  }

  public function setupEvents(fn: (win: ChatterWindow) -> Void) {
    fn(this);
  }

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

  public override function update() {
    super.update();
    this.updateMove();
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
