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
  var enableEventNames: Bool;
  var maxChatterWindows: Int;
  var marginPadding: Int;
  var animationTypeNotification: NotifAnimType;
  var notificationStayTime: Int;
  var enableItemNotifications: Bool;
  var enableNotifications: Bool;
};

enum abstract NotifAnimType(String) from String to String {
  public var SLIDE = 'slide';
  public var FADE = 'fade';
}

enum abstract EventAnimType(String) from String to String {
  public var FADE = 'fade';
  public var POP = 'pop';
}

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
  public var PUSHNOTIF = 'pushNotification';

  /**
   * Pushes an item notification with gain or loss.
   */
  public var PUSHITEMNOTIF = 'pushItemNotification';

  /**
   * Pushes a notification to the window that displays the character
   * face and other information.
   */
  public var PUSHCHARNOTIF = 'pushCharacterNotification';

  public var PUSHFACENOTIF = 'pushFaceNotification';
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
