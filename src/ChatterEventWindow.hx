import utils.Fn;
import rm.core.TouchInput;
import Types.ChatterEvents;
import rm.Globals;
import rm.sprites.Sprite_Character;
import rm.objects.Game_Event;

using core.NumberExtensions;

class ChatterEventWindow extends ChatterWindow {
  public var event: Game_Event;
  public var eventSprite: Sprite_Character;
  public var hovered: Bool;
  public var playerInRange: Bool;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    super(x, y, width, height);
    this.setBGType();
    this.hovered = false;
    this.playerInRange = false;
  }

  public function setBGType(?num: Int) {
    if (num != null) {
      switch (num) {
        case 0:
          this.setBackgroundType(0);
        case 1:
          this.setBackgroundType(1);
        case _:
          this.setBackgroundType(2);
      }
    } else {
      this.setBackgroundType(Main.CHParams.eventBackgroundType);
    }
  }

  public function setEvent(evt: Game_Event) {
    this.event = evt;
  }

  public function setEventSprite(evt: Sprite_Character) {
    this.eventSprite = evt;
  }

  public override function updateMove() {}

  public override function updateFade() {}

  public override function update() {
    super.update();
    this.scanForPlayer();
    this.scanForHover();
    this.paint();
  }

  public function scanForPlayer() {
    var eventX = this.event.screenX();
    var eventY = this.event.screenY();
    var playerX = Globals.GamePlayer.screenX();
    var playerY = Globals.GamePlayer.screenY();

    var inRange = Math.sqrt(Math.pow(playerX - eventX, 2)
      + Math.pow(playerY - eventY, 2)) < Main.CHParams.eventWindowRange;

    if (inRange) {
      this.emit(ChatterEvents.PLAYERINRANGE, this);
    } else {
      this.emit(ChatterEvents.PLAYEROUTOFRANGE, this);
    }
  }

  public function scanForHover() {
    var eventScreenX = this.event.screenX();
    var eventScreenY = this.event.screenY();
    var inputPosition = { x: TouchInput.x, y: TouchInput.y };

    if (inputPosition.x.withinRangef(eventScreenX, eventScreenX + 48)
      && inputPosition.y.withinRangef(eventScreenY - 48, eventScreenY)) {
      this.emit(ChatterEvents.ONHOVER, this);
    } else {
      this.emit(ChatterEvents.ONHOVEROUT, this);
    }
  }

  public function drawByType(str: String, x: Float, y: Float, width: Float, align: String) {
    var re = ~/<lcevent:\s*(\w+)\s+(\d)>/ig;
    var imgRe = ~/<lceventImg:\s*(\w+)\s+(\d)>/ig;
    switch (str) {
      case re.match(_) => true:
        #if compileMV
        this.drawTextEx(re.matched(1), x, y);
        #else
        this.drawTextEx(re.matched(1), x, y, width);
        #end

        this.setBGType(Fn.parseIntJs(re.matched(2)));
      case imgRe.match(_) => true:
        this.setBGType(Fn.parseIntJs(imgRe.matched(2)));
      case _:
        // Do Nothing
    }
  }
}
