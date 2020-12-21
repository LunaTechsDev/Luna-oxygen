package system;

import rm.scenes.Scene_Base;
import widgets.Layout;
import pixi.interaction.EventEmitter;

@:keep
@:native('OxUISystem')
@:expose('OxUISystem')
class UISystem extends EventEmitter {
  public var isStarted: Bool;
  public var currentLayout: Layout;

  public function setLayout(layout: Layout) {
    this.currentLayout = layout;
  }

  public function addToScene() {
    var currentScene: Scene_Base = Amaryllis.currentScene();
    currentScene.addChild(this.currentLayout);
  }

  public function start() {
    this.isStarted = true;
    this.emit(START);
  }

  public function update() {
    this.emit(UPDATE);
  }

  public function stop() {
    this.isStarted = false;
    this.emit(STOP);
  }
}
