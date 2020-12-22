package widgets;

import widgets.Panel.PanelConfig;

typedef GridPanelConfig = {
  > PanelConfig,
  var cols: Int;
  var rows: Int;
}

@:keep
@:native('OxGridPanel')
@:expose('OxGridPanel')
class GridPanel extends Panel {
  public var cols: Int;
  public var rows: Int;

  public function new(config: GridPanelConfig) {
    super(config);
  }

  override public function set(config: PanelConfig) {
    super.set(config);
    var gridPanelConfig: GridPanelConfig = cast config;
    this.cols = gridPanelConfig.cols;
    this.rows = gridPanelConfig.rows;
  }
}
