package widgets;

import pixi.core.display.Container;

@:keep
@:native('OxLayout')
@:expose('OxLayout')
class Layout extends Container {
  public function childrenCount() {
    return this.children.length;
  }

  public function organizeElements() {}
}
