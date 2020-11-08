import rm.scenes.Scene_Map as RmScene_Map;

class SceneMap extends RmScene_Map {
  public override function createAllWindows() {
    untyped _Scene_Map_createAllWindows.call(this);
    LunaChatter.createAllEventWindows(this);
  }
}
