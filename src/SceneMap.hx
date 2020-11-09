import rm.core.Graphics;
import rm.Globals;
import Types.ChatterEvents;
import rm.scenes.Scene_Map as RmScene_Map;

using Lambda;

class SceneMap extends RmScene_Map {
  public function setupLCNotificationEvents() {
    var listener = Main.ChatterEmitter;

    listener.on(ChatterEvents.PUSHNOTIF, (text) -> {
      // Start Queue and Transition Window
      var win = Main.chatterWindows.pop();
      win.drawText(text, 0, 0, win.contentsWidth(), 'left');
      win.move(0, 0);
      listener.emit(ChatterEvents.QUEUE, win);
    });
  }

  public override function createAllWindows() {
    untyped _Scene_Map_createAllWindows.call(this);
    this.createAllLCWindows();
    this.createAllLCEventWindows();
    this.setupLCNotificationEvents();
  }

  public function createAllLCWindows() {
    // Create notification windows based on maximum
    // keep them hidden until ready to use
    for (x in 0...Main.CHParams.maxChatterWindows) {
      var pos = switch (Main.CHParams.anchorPosition) {
        case BOTTOMLEFT:
          { x: 0, y: Graphics.boxHeight };
        case BOTTOMRIGHT:
          { x: Graphics.boxWidth, y: Graphics.boxHeight };
        case TOPLEFT:
          { x: 0, y: 0 }
        case TOPRIGHT:
          { x: Graphics.boxWidth, y: 0 };
      }
      var chatterWindow = new ChatterWindow(cast pos.x, cast pos.y, 200, 75);
      Main.chatterWindows.push(chatterWindow);
      this.addWindow(chatterWindow);
      trace('Created ', x + 1, ' windows');
    }
  }

  public function createAllLCEventWindows() {
    // Scan Events With Notetags to show event information
    var mapEvents = Globals.GameMap.events();
    // Add NoteTag Check Later -- + Add Events
    if (Main.CHParams.enableEventNames) {
      mapEvents.iter((event) -> {
        var chatterEventWindow = new ChatterEventWindow(0, 0, 100, 100);
        chatterEventWindow.setEvent(event);

        this._spriteset.__characterSprites.iter((charSprite) -> {
          if (charSprite.x == event.screenX() && charSprite.y == event.screenY()) {
            chatterEventWindow.setEventSprite(charSprite);
            charSprite.addChild(chatterEventWindow);
            charSprite.bitmap.addLoadListener((_) -> {
              Main.positionEventWindow(chatterEventWindow);
            });
            chatterEventWindow.close();
          }
        });

        chatterEventWindow.setupEvents(cast this.setupGameEvtEvents);
        chatterEventWindow.open();
      });
    }
  }

  public function setupGameEvtEvents(currentWindow: ChatterEventWindow) {
    currentWindow.on(ChatterEvents.PLAYERINRANGE, (win: ChatterEventWindow) -> {
      if (!win.playerInRange) {
        openChatterWindow(win);
        win.playerInRange = true;
      }
    });

    currentWindow.on(ChatterEvents.PLAYEROUTOFRANGE, (win: ChatterEventWindow) -> {
      if (win.playerInRange) {
        closeChatterWindow(win);
        win.playerInRange = false;
      }
    });

    currentWindow.on(ChatterEvents.ONHOVER, (win: ChatterEventWindow) -> {
      if (!win.hovered && !win.playerInRange) {
        openChatterWindow(win);
        win.hovered = true;
      }
    });

    currentWindow.on(ChatterEvents.ONHOVEROUT, (win: ChatterEventWindow) -> {
      if (win.hovered) {
        closeChatterWindow(win);
        win.hovered = false;
      }
    });

    currentWindow.on(ChatterEvents.PAINT, (win: ChatterEventWindow) -> {
      win.drawText(win.event.event().name, 0, 0, win.contentsWidth(), 'center');
    });
  }

  // ======================
  // Chatter Windows

  public function showChatterWindow(win: ChatterWindow) {
    win.show();
  }

  public function hideChatterWindow(win: ChatterWindow) {
    win.hide();
  }

  public function openChatterWindow(win: ChatterWindow) {
    win.open();
  }

  public function closeChatterWindow(win: ChatterWindow) {
    win.close();
  }
}
