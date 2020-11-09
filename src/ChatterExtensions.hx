import rm.types.RM.TextState;
import rm.windows.Window_Base;
import Types.JSTemplate;
import Types.TemplateString;
import rm.sprites.Sprite_Character;
import rm.objects.Game_Event;

using Lambda;

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

  public static function processTemplateString(win: Window_Base, templateIndex: Int, textState: TextState) {
    var templateStr: TemplateString = Main.CHParams.templateStrings.find((ts) -> ts.id == templateIndex);
    var text = templateStr.text;
    #if compileMV
    win.drawTextEx(text, textState.x, textState.y);
    #else
    win.drawTextEx(text, textState.x, textState.y, win.contentsWidth());
    #end
  }

  public static function processJSTemplateString(win: Window_Base, templateIndex: Int, textState: TextState) {
    var templateJsStr: JSTemplate = Main.CHParams.templateJSStrings.find((ts: Dynamic) -> ts.id == templateIndex);
    var code = templateJsStr.code;
    var text = js.Syntax.code('new Function({0})()', code);
    trace(templateJsStr);
    #if compileMV
    win.drawTextEx(text, textState.x, textState.x);
    #else
    win.drawTextEx(text, textState.x, textState.y, win.contentsWidth());
    #end
  }
}
