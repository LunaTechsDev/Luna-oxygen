/**
 * Chatter Template for creating custom chatter windows.
 */
typedef ChatterTemplate = {
  var id: Int;
}

typedef TemplateString = {
  > ChatterTemplate,
  var text: String;
}

typedef JSTemplate = {
  > ChatterTemplate,
  var code: String;
}

typedef CHParams = {
  var fadeInTime: Int;
  var fadeOutTime: Int;
  var eventWindowRange: Int;
  var anchorPosition: AnchorPos;
  var backgroundType: Int;
  var eventBackgroundType: Int;
  var templateStrings: Array<TemplateString>;
  var templateJSStrings: Array<JSTemplate>;
};

enum abstract ChatterType(String) from String to String {
  public var TEXT = 'text';
  public var ACTOR = 'actor';
  public var FACE = 'face';
  public var PIC = 'picture';
  public var MAP = 'map';
}

enum abstract AnchorPos(String) from String to String {
  public var TOPRIGHT = 'topRight';
  public var BOTTOMRIGHT = 'bottomRight';
  public var TOPLEFT = 'topLeft';
  public var BOTTOMLEFT = 'bottomLeft';
}

enum abstract ChatterEvents(String) from String to String {
  public var SHOW = 'show';
  public var PUSH = 'push';
  public var HIDE = 'hide';
  public var CLOSE = 'close';
  public var OPEN = 'open';
  public var QUEUE = 'queue';
  public var PAINT = 'paint';
  public var DEQUEUE = 'dequeue';
  public var PLAYERINRANGE = 'playerInRange';
  public var PLAYEROUTOFRANGE = 'playerOutOfRange';
  public var ONHOVER = 'onHover';
  public var ONHOVEROUT = 'onHoverOut';
}
