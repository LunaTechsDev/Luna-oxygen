import macros.FnMacros;
import rm.windows.Window_Base as RmWindow_Base;

@:native('LunaConfig')
@:expose('LunaConfig')
class Main {
  public static var Params: Params;
  public static var params = Globals.Plugins.filter((plugin) ->
    ~/<LunaConfig>/ig.match(plugin.description))[0].parameters;

  public static function main() {
    Comment.title('Parameter Setup');
    Params = {
      windowBackOpacity: Fn.parseIntJs(params['windowBackOpacity']),
    }

    Comment.title('Window_Base');
    FnMacros.jsPatch(true, RmWindow_Base, WindowBase);
  }
}
