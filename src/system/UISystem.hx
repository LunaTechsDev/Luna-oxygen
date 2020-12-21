package system;

import pixi.interaction.EventEmitter;

class UISystem extends EventEmitter {
  public var isStarted: Bool;

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
