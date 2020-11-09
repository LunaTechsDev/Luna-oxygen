import Types;
import macros.FnMacros;
import rm.core.JsonEx;
import rm.scenes.Scene_Map as RmScene_Map;
import rm.windows.Window_Base as RmWindow_Base;
import core.Amaryllis;
import utils.Comment;
import utils.Fn;
import rm.Globals;

using ChatterExtensions;
using Lambda;
using StringTools;
using core.NumberExtensions;

@:native('LunaChatter')
@:expose('LunaChatter')
class LunaChatter {
  public static var ChatterEmitter = Amaryllis.createEventEmitter();
  public static var CHParams: CHParams;
  public static var params = Globals.Plugins.filter((plugin) ->
    ~/<LunaChatter>/ig.match(plugin.description))[0].parameters;
  public static var chatterQueue: Array<ChatterWindow> = [];
  public static var chatterWindows: Array<ChatterWindow> = [];

  public static function main() {
    Comment.title('Parameter Setup');
    CHParams = {
      fadeInTime: Fn.parseIntJs(params['fadeInTime']),
      fadeOutTime: Fn.parseIntJs(params['fadeOutTime']),
      eventWindowRange: Fn.parseIntJs(params['eventWindowRange']),
      anchorPosition: params['anchorPosition'].trim(),
      backgroundType: Fn.parseIntJs(params['backgroundType']),
      eventBackgroundType: Fn.parseIntJs(params['eventBackgroundType']),
      templateStrings: JsonEx.parse(params['templateStrings']),
      templateJSStrings: JsonEx.parse(params['templateJSStrings']),
      enableEventNames: params['enableEventNames'].trim() == 'true'
    }

    CHParams.templateJSStrings = cast CHParams.templateJSStrings.map((ts) -> JsonEx.parse(cast ts));
    CHParams.templateStrings = cast CHParams.templateStrings.map((ts) -> JsonEx.parse(cast ts));
    trace(CHParams);

    Comment.title('Event Hooks');
    setupEvents();

    Comment.title('Scene_Map');
    FnMacros.jsPatch(true, RmScene_Map, SceneMap);

    Comment.title('Window_Base');
    FnMacros.jsPatch(true, RmWindow_Base, WindowBase);
  }

  public static function setupEvents() {
    ChatterEmitter.on(ChatterEvents.QUEUE, (win: ChatterWindow) -> {
      queueChatterWindow(win);
    });
    ChatterEmitter.on(ChatterEvents.DEQUEUE, () -> {
      dequeueChatterWindow();
    });
  }

  // ============================
  // Chatter Event Windows
  public static function createAllEventWindows(scene: RmScene_Map) {
    // Scan Events With Notetags to show event information
    var mapEvents = Globals.GameMap.events();
    // Add NoteTag Check Later -- + Add Events
    if (CHParams.enableEventNames) {
      mapEvents.iter((event) -> {
        var chatterEventWindow = new ChatterEventWindow(0, 0, 100, 100);
        chatterEventWindow.setEvent(event);

        scene.__spriteset.__characterSprites.iter((charSprite) -> {
          if (charSprite.x == event.screenX() && charSprite.y == event.screenY()) {
            chatterEventWindow.setEventSprite(charSprite);
            charSprite.addChild(chatterEventWindow);
            charSprite.bitmap.addLoadListener((_) -> {
              positionEventWindow(chatterEventWindow);
            });
            chatterEventWindow.close();
          }
        });

        chatterEventWindow.setupEvents(cast setupGameEvtEvents);
        chatterEventWindow.open();
      });
    }
  }

  public static function setupGameEvtEvents(currentWindow: ChatterEventWindow) {
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

  public static function showChatterEventWindow() {
    // Update Position On Within Range
  }

  public static function positionEventWindow(win: ChatterEventWindow) {
    var offset = win.eventSprite.offsetByEventSprite();
    win.x -= win.width / 2;
    win.y -= (win.height + (offset.y));
  }

  // ======================
  // Chatter Windows
  public static function queueChatterWindow(win: ChatterWindow) {
    // Perform Show Transition
    chatterQueue.enqueue(win);
  }

  public static function dequeueChatterWindow(): ChatterWindow {
    // Perform Transition
    return chatterQueue.dequeue();
  }

  public static function showChatterWindow(win: ChatterWindow) {
    win.show();
  }

  public static function hideChatterWindow(win: ChatterWindow) {
    win.hide();
  }

  public static function openChatterWindow(win: ChatterWindow) {
    win.open();
  }

  public static function closeChatterWindow(win: ChatterWindow) {
    win.close();
  }
}
