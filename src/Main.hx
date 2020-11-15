import rm.types.RPG.BaseItem;
import Types;
import macros.FnMacros;
import rm.core.JsonEx;
import rm.scenes.Scene_Map as RmScene_Map;
import rm.windows.Window_Base as RmWindow_Base;
import rm.objects.Game_Party as RmGame_Party;
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
class Main {
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
      enableEventNames: params['enableEventNames'].trim() == 'true',
      maxChatterWindows: Fn.parseIntJs(params['maxChatterWindows']),
      marginPadding: Fn.parseIntJs(params['marginPadding']),
      animationTypeNotification: params['animationTypeNotification'].trim(),
      notificationStayTime: Fn.parseIntJs(params['notificationStayTime']),
      enableItemNotifications: params['enableItemNotifications'].trim() == 'true'
    }

    CHParams.templateJSStrings = cast CHParams.templateJSStrings.map((ts) -> JsonEx.parse(cast ts));
    CHParams.templateStrings = cast CHParams.templateStrings.map((ts) -> JsonEx.parse(cast ts));
    trace(CHParams);

    Comment.title('Scene_Map');
    FnMacros.jsPatch(true, RmScene_Map, SceneMap);

    Comment.title('Window_Base');
    FnMacros.jsPatch(true, RmWindow_Base, WindowBase);

    Comment.title('Game_Party');
    FnMacros.jsPatch(true, RmGame_Party, GameParty);
  }

  // ============================
  // Chatter Event Windows
  public static function showChatterEventWindow() {
    // Update Position On Within Range
  }

  public static function positionEventWindow(win: ChatterEventWindow) {
    var offset = win.eventSprite.offsetByEventSprite();
    win.x -= win.width / 2;
    win.y -= (win.height + (offset.y));
  }

  public static function pushTextNotif(text: String) {
    ChatterEmitter.emit(ChatterEvents.PUSHNOTIF, text);
  }

  public static function pushItemNotif(item: BaseItem, amount: Int) {
    if (CHParams.enableItemNotifications) {
      ChatterEmitter.emit(ChatterEvents.PUSHITEMNOTIF, item, amount);
    }
  }

  public static function pushCharNotif(text: String, charName: String, charIndex: Int) {
    ChatterEmitter.emit(ChatterEvents.PUSHCHARNOTIF, text, charName, charIndex);
  }

  public static function queueChatterWindow(win: ChatterWindow) {
    // Perform Show Transition
    chatterQueue.enqueue(win);
  }

  public static function dequeueChatterWindow(): ChatterWindow {
    // Perform Exit Transition
    return chatterQueue.dequeue();
  }
}
