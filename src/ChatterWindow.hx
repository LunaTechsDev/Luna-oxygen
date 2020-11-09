import rm.core.Rectangle;
import Types.ChatterEvents;
import rm.windows.Window_Base;

class ChatterWindow extends Window_Base {
  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
    this.setBGType();
  }

  public function setBGType() {
    this.setBackgroundType(Main.CHParams.backgroundType);
  }

  public function setupEvents(fn: (win: ChatterWindow) -> Void) {
    fn(this);
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
