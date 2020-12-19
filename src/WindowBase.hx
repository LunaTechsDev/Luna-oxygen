import rm.windows.Window_Base as RmWindow_Base;

class WindowBase extends RmWindow_Base {
  public override function updateBackOpacity() {
    this.backOpacity = Main.Params.windowBackOpacity;
  }
}
