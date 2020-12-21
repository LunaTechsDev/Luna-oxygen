typedef Params = {
  var windowBackOpacity: Int;
};

enum abstract GaugeStyle(String) from String to String {
  public var RSLANT = 'rS';
  public var LSLANT = 'lS';
  public var RBOX = 'rB';
  public var LBOX = 'lB';
  public var RARROW = 'rA';
  public var LARROW = 'lA';
}
