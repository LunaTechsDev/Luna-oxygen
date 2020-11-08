class ChatterEventWindow extends ChatterWindow {
  public var event: Game_Event;
  public var eventSprite: Sprite_Character;
  public var hovered: Bool;
  public var playerInRange: Bool;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    super(x, y, width, height);
    this.hovered = false;
    this.playerInRange = false;
  }

  public override function setBGType() {
    this.setBackgroundType(LunaChatter.CHParams.eventBackgroundType);
  }

  public function setEvent(evt: Game_Event) {
    this.event = evt;
  }

  public function setEventSprite(evt: Sprite_Character) {
    this.eventSprite = evt;
  }

  public override function update() {
    super.update();
    this.scanForPlayer();
    this.scanForHover();
    this.paint();
  }
}
