import widgets.TilingPic;
import rm.managers.ImageManager;
import widgets.Pic;
import widgets.Panel;
import widgets.Gauge;
import macros.FnMacros;
import rm.windows.Window_Base as RmWindow_Base;

@:native('LunaConfig')
@:expose('LunaConfig')
class Main {
  public static var Params: Params;
  public static var params = Globals.Plugins.filter((plugin) ->
    ~/<LunaOxygen>/ig.match(plugin.description))[0].parameters;

  public static function main() {
    Comment.title('Parameter Setup');
    Params = {
      windowBackOpacity: Fn.parseIntJs(params['windowBackOpacity']),
    }

    Comment.title('Window_Base');
    FnMacros.jsPatch(true, RmWindow_Base, WindowBase);
    var gauge = new Gauge({
      x: 0,
      y: 0,
      width: 100,
      height: 25,
      rate: .70,
      bgColor: 'black',
      color: 'white',
      leftStyle: LBOX,
      rightStyle: LARROW,
    });

    var pic = new Pic({
      x: 0,
      y: 26,
      width: 150,
      height: 125,
      bitmap: ImageManager.loadPicture('Forest')
    });

    var tpic = new TilingPic({
      x: 0,
      y: 130,
      width: 150,
      height: 125,
      bitmap: ImageManager.loadPicture('Forest'),
      scrollX: -0.64,
      scrollY: 0.3
    });

    var panel = new Panel({
      x: 200,
      y: 300,
      width: 250,
      height: 250,
      bgColor: 'pink'
    });
    panel.addChild(gauge);
    panel.addChild(pic);
    panel.addChild(tpic);
    trace(gauge);
    untyped console.log(panel);
  }
}
