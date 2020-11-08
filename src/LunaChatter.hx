import Types;
import macros.FnMacros;
import rm.core.JsonEx;
import rm.sprites.Sprite_Character;
import rm.core.TouchInput;
import rm.objects.Game_Event;
import rm.scenes.Scene_Map as RmScene_Map;
import rm.windows.Window_Base;
import core.Amaryllis;
import rm.types.RM.TextState;
import utils.Comment;
import core.Types.JsFn;
import utils.Fn;
import rm.Globals;

using LunaChatter.ChatterExtensions;
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
      templateJSStrings: JsonEx.parse(params['templateJSStrings'])
    }

    CHParams.templateJSStrings = cast CHParams.templateJSStrings.map((ts) -> JsonEx.parse(cast ts));
    CHParams.templateStrings = cast CHParams.templateStrings.map((ts) -> JsonEx.parse(cast ts));
    trace(CHParams);

    Comment.title('Event Hooks');
    setupEvents();

    Comment.title('Scene_Map');
    FnMacros.jsPatch(true, RmScene_Map, SceneMap);
  }

  public static function setupEvents() {
    ChatterEmitter.on(ChatterEvents.QUEUE, (win: ChatterWindow) -> {
      queueChatterWindow(win);
    });
    ChatterEmitter.on(ChatterEvents.DEQUEUE, () -> {
      dequeueChatterWindow();
    });

    Comment.title('Window_Base');
    var _WindowBaseEscapeCharacter: JsFn = Fn.proto(Window_Base).processEscapeCharacterR;
    Fn.proto(Window_Base).processEscapeCharacterD = (code: String, textState: TextState) -> {
      var winBase: Window_Base = Fn.self;
      switch (code) {
        case 'LCT':
          processTemplateString(winBase, cast winBase.obtainEscapeParam(textState), textState);
        case 'LCJS':
          processJSTemplateString(winBase, cast winBase.obtainEscapeParam(textState), textState);
        case _:
          _WindowBaseEscapeCharacter.call(Fn.self, code, textState);
      }
    };
  }

  public static function processTemplateString(win: Window_Base, templateIndex: Int, textState: TextState) {
    var templateStr: TemplateString = LunaChatter.CHParams.templateStrings.find((ts) -> ts.id == templateIndex);
    var text = templateStr.text;
    #if compileMV
    win.drawTextEx(text, textState.x, textState.y);
    #else
    win.drawTextEx(text, textState.x, textState.y, win.contentsWidth());
    #end
  }

  public static function processJSTemplateString(win: Window_Base, templateIndex: Int, textState: TextState) {
    var templateJsStr: JSTemplate = LunaChatter.CHParams.templateJSStrings.find((ts: Dynamic) ->
      ts.id == templateIndex);
    var code = templateJsStr.code;
    var text = js.Syntax.code('new Function({0})()', code);
    trace(templateJsStr);
    #if compileMV
    win.drawTextEx(text, textState.x, textState.x);
    #else
    win.drawTextEx(text, textState.x, textState.y, win.contentsWidth());
    #end
  }

  public static function createAllEventWindows(scene: RmScene_Map) {
    // Scan Events With Notetags to show event information
    var mapEvents = Globals.GameMap.events();
    // Add NoteTag Check Later -- + Add Events
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

  public static function positionEventWindow(win: ChatterEventWindow) {
    var offset = win.eventSprite.offsetByEventSprite();
    win.x -= win.width / 2;
    win.y -= (win.height + (offset.y));
  }

  public static function closeChatterWindow(win: ChatterWindow) {
    win.close();
  }
}

class ChatterExtensions {
  public static function enqueue<T>(arr: Array<T>, element: T) {
    arr.push(element);
  }

  public static function dequeue<T>(arr: Array<T>): T {
    return arr.shift();
  }

  public static function offsetAboveEvent(evt: Game_Event) {
    var eventScreenXCenter = evt.screenX() - 24;
    var eventScreenYAbove = evt.screenY() - 64;
    return { x: eventScreenXCenter, y: eventScreenYAbove };
  }

  public static function offsetByEventSprite(charSprite: Sprite_Character) {
    charSprite.updateFrame();
    return { x: charSprite.__frame.width / 2, y: charSprite.__frame.height };
  }

  public function scanForPlayer() {
    var eventX = this.event.screenX();
    var eventY = this.event.screenY();
    var playerX = Globals.GamePlayer.screenX();
    var playerY = Globals.GamePlayer.screenY();

    var inRange = Math.sqrt(Math.pow(playerX - eventX, 2)
      + Math.pow(playerY - eventY, 2)) < LunaChatter.CHParams.eventWindowRange;

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
}
