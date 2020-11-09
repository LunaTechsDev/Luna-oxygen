/** ============================================================================
 *
 *  Luna_Chatter.js
 * 
 *  Build Date: 11/8/2020
 * 
 *  Made with LunaTea -- Haxe
 *
 * =============================================================================
*/
// Generated by Haxe 4.1.3
/*:
@author LunaTechs - Kino
@plugindesc This plugin allows you to create notifications and event labels within RPGMakerMV/MZ <LunaChatter>.

@target MV MZ

@param audioBytes
@desc The audio files to use when playing sound
@type struct<SoundFile>[]

@param maxChatterWindows
@text Maximum Chatter Windows
@desc The maximum number of chatter windows available on screen
@default 10

@param fadeInTime
@text Fade In Time
@desc The time in frames to fade in the chatter window as it enters the screen.
@default 120

@param fadeOutTime
@text Fade Out Time
@desc The time in frames to fade out the chatter window as it leaves the screen.
@default 120

@param enableEventNames
@text Enable Event Names
@desc Enables event names in the editor (true/false)
@default true

@param eventWindowRange
@text Event Window Range
@desc The radius in pixels in which the player will see the chatter window.
@default 120

@param anchorPosition
@text Anchor Position
@desc The anchor position of the  notification windows (topRight, bottomRight, topLeft, bottomLeft).
@default topRight

@param backgroundType
@text Background Type
@desc The background type of the chatter windows.
@default 0

@param eventBackgroundType
@text Event Background Type
@desc The background type of the event chatter windows. 
@default 2

@param templateStrings
@text Template Strings
@desc The template strings that you can draw within the
text window.
@type struct<Template>[]

@param templateJSStrings
@text Template JavaScript Strings
@desc The template JavaScripts you can embed within
the chatter window.
@type struct<JSTemplate>[]


@help
This plugin allows you to have a press start button before the title screen information.

MIT License
Copyright (c) 2020 LunaTechsDev
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
*/

/*~struct~Template:
 *
 * @param id
 * @text Identifier
 * @desc The identifier used for this text template.
 * @default 1
 *
 * @param text
 * @text Text
 * @type note
 * @desc The text for the string template; has text code support.
 * @default \N[1]: Hello Tim
 *
 */

/*~struct~JSTemplate:
 * @param id
 * @text Identifier
 * @desc The identifier used for the JS template.
 * @default 1
 *
 * @param code
 * @text Code
 * @type note
 * @desc The code for the code template.
 * @default `${$gameActors.actor(1).name}`;
 */

/*~struct~SoundFile:
 * @param id
 * @text Identifier
 * @desc The identifier used in the text window
 * @type text
 *
 * @param name
 * @text Name
 * @desc The name of the audio SE file
 * @type file
 *
 * @param pitch
 * @text Pitch
 * @desc The pitch of the audio file
 * @type number
 * @default 100
 *
 * @param volume
 * @text Volume
 * @desc The volume of the audio file
 * @type number
 * @default 50
 *
 * @param pan
 * @text Pan
 * @desc The pan of the audio file
 * @type number
 * @default 100
 *
 */
(function ($hx_exports, $global) {
  "use strict";
  var $estr = function () {
      return js_Boot.__string_rec(this, "");
    },
    $hxEnums = $hxEnums || {};
  class ChatterWindow extends Window_Base {
    constructor(x, y, width, height) {
      super(new Rectangle(x, y, width, height));
      this.setBGType();
    }
    setBGType() {
      this.setBackgroundType(LunaChatter.CHParams.backgroundType);
    }
    setupEvents(fn) {
      fn(this);
    }
    paint() {
      if (this.contents != null) {
        this.contents.clear();
        this.emit("paint", this);
      }
    }
    show() {
      this.emit("show", this);
      super.show();
    }
    hide() {
      this.emit("hide", this);
      super.hide();
    }
    open() {
      this.emit("open", this);
      super.open();
    }
    close() {
      this.emit("close", this);
      super.close();
    }
  }

  ChatterWindow.__name__ = true;
  class ChatterEventWindow extends ChatterWindow {
    constructor(x, y, width, height) {
      super(x, y, width, height);
      this.hovered = false;
      this.playerInRange = false;
    }
    setBGType() {
      this.setBackgroundType(LunaChatter.CHParams.eventBackgroundType);
    }
    setEvent(evt) {
      this.event = evt;
    }
    setEventSprite(evt) {
      this.eventSprite = evt;
    }
    update() {
      super.update();
      this.scanForPlayer();
      this.scanForHover();
      this.paint();
    }
    scanForPlayer() {
      let eventX = this.event.screenX();
      let eventY = this.event.screenY();
      let playerX = $gamePlayer.screenX();
      let playerY = $gamePlayer.screenY();
      if (
        Math.sqrt(
          Math.pow(playerX - eventX, 2) + Math.pow(playerY - eventY, 2)
        ) < LunaChatter.CHParams.eventWindowRange
      ) {
        this.emit("playerInRange", this);
      } else {
        this.emit("playerOutOfRange", this);
      }
    }
    scanForHover() {
      let eventScreenX = this.event.screenX();
      let eventScreenY = this.event.screenY();
      let inputPosition_x = TouchInput.x;
      let inputPosition_y = TouchInput.y;
      if (
        inputPosition_x >= eventScreenX &&
        inputPosition_x <= eventScreenX + 48 &&
        inputPosition_y >= eventScreenY - 48 &&
        inputPosition_y <= eventScreenY
      ) {
        this.emit("onHover", this);
      } else {
        this.emit("onHoverOut", this);
      }
    }
  }

  ChatterEventWindow.__name__ = true;
  class ChatterExtensions {
    static enqueue(arr, element) {
      arr.push(element);
    }
    static dequeue(arr) {
      return arr.shift();
    }
    static offsetByEventSprite(charSprite) {
      charSprite.updateFrame();
      return { x: charSprite._frame.width / 2, y: charSprite._frame.height };
    }
    static processTemplateString(win, templateIndex, textState) {
      win.drawTextEx(
        Lambda.find(LunaChatter.CHParams.templateStrings, function (ts) {
          return ts.id == templateIndex;
        }).text,
        textState.x,
        textState.y,
        win.contentsWidth()
      );
    }
    static processJSTemplateString(win, templateIndex, textState) {
      let templateJsStr = Lambda.find(
        LunaChatter.CHParams.templateJSStrings,
        function (ts) {
          return ts.id == templateIndex;
        }
      );
      let text = new Function(templateJsStr.code)();
      haxe_Log.trace(templateJsStr, {
        fileName: "src/ChatterExtensions.hx",
        lineNumber: 44,
        className: "ChatterExtensions",
        methodName: "processJSTemplateString",
      });
      win.drawTextEx(text, textState.x, textState.y, win.contentsWidth());
    }
  }

  ChatterExtensions.__name__ = true;
  class EReg {
    constructor(r, opt) {
      this.r = new RegExp(r, opt.split("u").join(""));
    }
    match(s) {
      if (this.r.global) {
        this.r.lastIndex = 0;
      }
      this.r.m = this.r.exec(s);
      this.r.s = s;
      return this.r.m != null;
    }
  }

  EReg.__name__ = true;
  class Lambda {
    static iter(it, f) {
      let x = $getIterator(it);
      while (x.hasNext()) f(x.next());
    }
    static find(it, f) {
      let v = $getIterator(it);
      while (v.hasNext()) {
        let v1 = v.next();
        if (f(v1)) {
          return v1;
        }
      }
      return null;
    }
  }

  Lambda.__name__ = true;

  class LunaChatter {
    static main() {
      //=============================================================================
      // Parameter Setup
      //=============================================================================
      let string = LunaChatter.params["fadeInTime"];
      let tmp = parseInt(string, 10);
      let string1 = LunaChatter.params["fadeOutTime"];
      let tmp1 = parseInt(string1, 10);
      let string2 = LunaChatter.params["eventWindowRange"];
      let tmp2 = parseInt(string2, 10);
      let tmp3 = LunaChatter.params["anchorPosition"].trim();
      let string3 = LunaChatter.params["backgroundType"];
      let tmp4 = parseInt(string3, 10);
      let string4 = LunaChatter.params["eventBackgroundType"];
      let tmp5 = parseInt(string4, 10);
      let tmp6 = JsonEx.parse(LunaChatter.params["templateStrings"]);
      let tmp7 = JsonEx.parse(LunaChatter.params["templateJSStrings"]);
      let tmp8 = LunaChatter.params["enableEventNames"].trim() == "true";
      let string5 = LunaChatter.params["maxChatterWindows"];
      LunaChatter.CHParams = {
        fadeInTime: tmp,
        fadeOutTime: tmp1,
        eventWindowRange: tmp2,
        anchorPosition: tmp3,
        backgroundType: tmp4,
        eventBackgroundType: tmp5,
        templateStrings: tmp6,
        templateJSStrings: tmp7,
        enableEventNames: tmp8,
        maxChatterWindows: parseInt(string5, 10),
      };
      let _this = LunaChatter.CHParams.templateJSStrings;
      let result = new Array(_this.length);
      let _g = 0;
      let _g1 = _this.length;
      while (_g < _g1) {
        let i = _g++;
        result[i] = JsonEx.parse(_this[i]);
      }
      LunaChatter.CHParams.templateJSStrings = result;
      let _this1 = LunaChatter.CHParams.templateStrings;
      let result1 = new Array(_this1.length);
      let _g2 = 0;
      let _g3 = _this1.length;
      while (_g2 < _g3) {
        let i = _g2++;
        result1[i] = JsonEx.parse(_this1[i]);
      }
      LunaChatter.CHParams.templateStrings = result1;
      haxe_Log.trace(LunaChatter.CHParams, {
        fileName: "src/Main.hx",
        lineNumber: 43,
        className: "Main",
        methodName: "main",
      });

      //=============================================================================
      // Event Hooks
      //=============================================================================
      LunaChatter.setupEvents();

      //=============================================================================
      // Scene_Map
      //=============================================================================
      let _Scene_Map_setupLCNotificationEvents =
        Scene_Map.prototype.setupLCNotificationEvents;
      Scene_Map.prototype.setupLCNotificationEvents = function () {
        let listener = LunaChatter.ChatterEmitter;
        listener.on("pushNotification", function (text) {
          let win = LunaChatter.chatterWindows.pop();
          win.drawText(text, 0, 0, win.contentsWidth(), "left");
          win.move(0, 0);
          listener.emit("queue", win);
        });
      };
      let _Scene_Map_createAllWindows = Scene_Map.prototype.createAllWindows;
      Scene_Map.prototype.createAllWindows = function () {
        _Scene_Map_createAllWindows.call(this);
        this.createAllLCWindows();
        this.createAllLCEventWindows();
        this.setupLCNotificationEvents();
      };
      let _Scene_Map_createAllLCWindows =
        Scene_Map.prototype.createAllLCWindows;
      Scene_Map.prototype.createAllLCWindows = function () {
        let _g = 0;
        let _g1 = LunaChatter.CHParams.maxChatterWindows;
        while (_g < _g1) {
          let x = _g++;
          let pos;
          switch (LunaChatter.CHParams.anchorPosition) {
            case "bottomLeft":
              pos = { x: 0, y: Graphics.boxHeight };
              break;
            case "bottomRight":
              pos = { x: Graphics.boxWidth, y: Graphics.boxHeight };
              break;
            case "topLeft":
              pos = { x: 0, y: 0 };
              break;
            case "topRight":
              pos = { x: Graphics.boxWidth, y: 0 };
              break;
          }

          let chatterWindow = new ChatterWindow(pos.x, pos.y, 200, 75);
          LunaChatter.chatterWindows.push(chatterWindow);
          this.addWindow(chatterWindow);
          haxe_Log.trace("Created ", {
            fileName: "src/SceneMap.hx",
            lineNumber: 45,
            className: "SceneMap",
            methodName: "createAllLCWindows",
            customParams: [x + 1, " windows"],
          });
        }
      };
      let _Scene_Map_createAllLCEventWindows =
        Scene_Map.prototype.createAllLCEventWindows;
      Scene_Map.prototype.createAllLCEventWindows = function () {
        let mapEvents = $gameMap.events();
        let _gthis = this;
        if (LunaChatter.CHParams.enableEventNames) {
          Lambda.iter(mapEvents, function (event) {
            let chatterEventWindow = new ChatterEventWindow(0, 0, 100, 100);
            chatterEventWindow.setEvent(event);
            Lambda.iter(_gthis._spriteset._characterSprites, function (
              charSprite
            ) {
              if (
                charSprite.x == event.screenX() &&
                charSprite.y == event.screenY()
              ) {
                chatterEventWindow.setEventSprite(charSprite);
                charSprite.addChild(chatterEventWindow);
                charSprite.bitmap.addLoadListener(function (_) {
                  LunaChatter.positionEventWindow(chatterEventWindow);
                });
                chatterEventWindow.close();
              }
            });
            chatterEventWindow.setupEvents(
              $bind(_gthis, _gthis.setupGameEvtEvents)
            );
            chatterEventWindow.open();
          });
        }
      };
      let _Scene_Map_setupGameEvtEvents =
        Scene_Map.prototype.setupGameEvtEvents;
      Scene_Map.prototype.setupGameEvtEvents = function (currentWindow) {
        let _gthis = this;
        currentWindow.on("playerInRange", function (win) {
          if (!win.playerInRange) {
            _gthis.openChatterWindow(win);
            win.playerInRange = true;
          }
        });
        currentWindow.on("playerOutOfRange", function (win) {
          if (win.playerInRange) {
            _gthis.closeChatterWindow(win);
            win.playerInRange = false;
          }
        });
        currentWindow.on("onHover", function (win) {
          if (!win.hovered && !win.playerInRange) {
            _gthis.openChatterWindow(win);
            win.hovered = true;
          }
        });
        currentWindow.on("onHoverOut", function (win) {
          if (win.hovered) {
            _gthis.closeChatterWindow(win);
            win.hovered = false;
          }
        });
        currentWindow.on("paint", function (win) {
          win.drawText(
            win.event.event().name,
            0,
            0,
            win.contentsWidth(),
            "center"
          );
        });
      };
      let _Scene_Map_showChatterWindow = Scene_Map.prototype.showChatterWindow;
      Scene_Map.prototype.showChatterWindow = function (win) {
        win.show();
      };
      let _Scene_Map_hideChatterWindow = Scene_Map.prototype.hideChatterWindow;
      Scene_Map.prototype.hideChatterWindow = function (win) {
        win.hide();
      };
      let _Scene_Map_openChatterWindow = Scene_Map.prototype.openChatterWindow;
      Scene_Map.prototype.openChatterWindow = function (win) {
        win.open();
      };
      let _Scene_Map_closeChatterWindow =
        Scene_Map.prototype.closeChatterWindow;
      Scene_Map.prototype.closeChatterWindow = function (win) {
        win.close();
      };

      //=============================================================================
      // Window_Base
      //=============================================================================
      let _Window_Base_processEscapeCharacter =
        Window_Base.prototype.processEscapeCharacter;
      Window_Base.prototype.processEscapeCharacter = function (
        code,
        textState
      ) {
        switch (code) {
          case "LCJS":
            ChatterExtensions.processJSTemplateString(
              this,
              this.obtainEscapeParam(textState),
              textState
            );
            break;
          case "LCT":
            ChatterExtensions.processTemplateString(
              this,
              this.obtainEscapeParam(textState),
              textState
            );
            break;
          default:
            _Window_Base_processEscapeCharacter.call(this, code, textState);
        }
      };
    }
    static setupEvents() {
      LunaChatter.ChatterEmitter.on("queue", function (win) {
        LunaChatter.queueChatterWindow(win);
      });
      LunaChatter.ChatterEmitter.on("dequeue", function () {
        LunaChatter.dequeueChatterWindow();
      });
    }
    static showChatterEventWindow() {}
    static positionEventWindow(win) {
      let offset = ChatterExtensions.offsetByEventSprite(win.eventSprite);
      win.x -= win.width / 2;
      win.y -= win.height + offset.y;
    }
    static pushTextNotification(text) {
      LunaChatter.ChatterEmitter.emit("pushNotification", text);
    }
    static queueChatterWindow(win) {
      ChatterExtensions.enqueue(LunaChatter.chatterQueue, win);
    }
    static dequeueChatterWindow() {
      return ChatterExtensions.dequeue(LunaChatter.chatterQueue);
    }
  }

  $hx_exports["LunaChatter"] = LunaChatter;
  LunaChatter.__name__ = true;
  Math.__name__ = true;
  class SceneMap extends Scene_Map {
    constructor() {
      super();
    }
    setupLCNotificationEvents() {
      let listener = LunaChatter.ChatterEmitter;
      listener.on("pushNotification", function (text) {
        let win = LunaChatter.chatterWindows.pop();
        win.drawText(text, 0, 0, win.contentsWidth(), "left");
        win.move(0, 0);
        listener.emit("queue", win);
      });
    }
    createAllWindows() {
      _Scene_Map_createAllWindows.call(this);
      this.createAllLCWindows();
      this.createAllLCEventWindows();
      this.setupLCNotificationEvents();
    }
    createAllLCWindows() {
      let _g = 0;
      let _g1 = LunaChatter.CHParams.maxChatterWindows;
      while (_g < _g1) {
        let x = _g++;
        let pos;
        switch (LunaChatter.CHParams.anchorPosition) {
          case "bottomLeft":
            pos = { x: 0, y: Graphics.boxHeight };
            break;
          case "bottomRight":
            pos = { x: Graphics.boxWidth, y: Graphics.boxHeight };
            break;
          case "topLeft":
            pos = { x: 0, y: 0 };
            break;
          case "topRight":
            pos = { x: Graphics.boxWidth, y: 0 };
            break;
        }

        let chatterWindow = new ChatterWindow(pos.x, pos.y, 200, 75);
        LunaChatter.chatterWindows.push(chatterWindow);
        this.addWindow(chatterWindow);
        haxe_Log.trace("Created ", {
          fileName: "src/SceneMap.hx",
          lineNumber: 45,
          className: "SceneMap",
          methodName: "createAllLCWindows",
          customParams: [x + 1, " windows"],
        });
      }
    }
    createAllLCEventWindows() {
      let mapEvents = $gameMap.events();
      let _gthis = this;
      if (LunaChatter.CHParams.enableEventNames) {
        Lambda.iter(mapEvents, function (event) {
          let chatterEventWindow = new ChatterEventWindow(0, 0, 100, 100);
          chatterEventWindow.setEvent(event);
          Lambda.iter(_gthis._spriteset._characterSprites, function (
            charSprite
          ) {
            if (
              charSprite.x == event.screenX() &&
              charSprite.y == event.screenY()
            ) {
              chatterEventWindow.setEventSprite(charSprite);
              charSprite.addChild(chatterEventWindow);
              charSprite.bitmap.addLoadListener(function (_) {
                LunaChatter.positionEventWindow(chatterEventWindow);
              });
              chatterEventWindow.close();
            }
          });
          chatterEventWindow.setupEvents(
            $bind(_gthis, _gthis.setupGameEvtEvents)
          );
          chatterEventWindow.open();
        });
      }
    }
    setupGameEvtEvents(currentWindow) {
      let _gthis = this;
      currentWindow.on("playerInRange", function (win) {
        if (!win.playerInRange) {
          _gthis.openChatterWindow(win);
          win.playerInRange = true;
        }
      });
      currentWindow.on("playerOutOfRange", function (win) {
        if (win.playerInRange) {
          _gthis.closeChatterWindow(win);
          win.playerInRange = false;
        }
      });
      currentWindow.on("onHover", function (win) {
        if (!win.hovered && !win.playerInRange) {
          _gthis.openChatterWindow(win);
          win.hovered = true;
        }
      });
      currentWindow.on("onHoverOut", function (win) {
        if (win.hovered) {
          _gthis.closeChatterWindow(win);
          win.hovered = false;
        }
      });
      currentWindow.on("paint", function (win) {
        win.drawText(
          win.event.event().name,
          0,
          0,
          win.contentsWidth(),
          "center"
        );
      });
    }
    openChatterWindow(win) {
      win.open();
    }
    closeChatterWindow(win) {
      win.close();
    }
  }

  SceneMap.__name__ = true;
  class Std {
    static string(s) {
      return js_Boot.__string_rec(s, "");
    }
  }

  Std.__name__ = true;
  class WindowBase extends Window_Base {
    constructor(rect) {
      super(rect);
    }
    processEscapeCharacter(code, textState) {
      switch (code) {
        case "LCJS":
          ChatterExtensions.processJSTemplateString(
            this,
            this.obtainEscapeParam(textState),
            textState
          );
          break;
        case "LCT":
          ChatterExtensions.processTemplateString(
            this,
            this.obtainEscapeParam(textState),
            textState
          );
          break;
        default:
          _Window_Base_processEscapeCharacter.call(this, code, textState);
      }
    }
  }

  WindowBase.__name__ = true;
  class haxe_Log {
    static formatOutput(v, infos) {
      let str = Std.string(v);
      if (infos == null) {
        return str;
      }
      let pstr = infos.fileName + ":" + infos.lineNumber;
      if (infos.customParams != null) {
        let _g = 0;
        let _g1 = infos.customParams;
        while (_g < _g1.length) str += ", " + Std.string(_g1[_g++]);
      }
      return pstr + ": " + str;
    }
    static trace(v, infos) {
      let str = haxe_Log.formatOutput(v, infos);
      if (typeof console != "undefined" && console.log != null) {
        console.log(str);
      }
    }
  }

  haxe_Log.__name__ = true;
  class haxe_iterators_ArrayIterator {
    constructor(array) {
      this.current = 0;
      this.array = array;
    }
    hasNext() {
      return this.current < this.array.length;
    }
    next() {
      return this.array[this.current++];
    }
  }

  haxe_iterators_ArrayIterator.__name__ = true;
  class js_Boot {
    static __string_rec(o, s) {
      if (o == null) {
        return "null";
      }
      if (s.length >= 5) {
        return "<...>";
      }
      let t = typeof o;
      if (t == "function" && (o.__name__ || o.__ename__)) {
        t = "object";
      }
      switch (t) {
        case "function":
          return "<function>";
        case "object":
          if (o.__enum__) {
            let e = $hxEnums[o.__enum__];
            let n = e.__constructs__[o._hx_index];
            let con = e[n];
            if (con.__params__) {
              s = s + "\t";
              return (
                n +
                "(" +
                (function ($this) {
                  var $r;
                  let _g = [];
                  {
                    let _g1 = 0;
                    let _g2 = con.__params__;
                    while (true) {
                      if (!(_g1 < _g2.length)) {
                        break;
                      }
                      let p = _g2[_g1];
                      _g1 = _g1 + 1;
                      _g.push(js_Boot.__string_rec(o[p], s));
                    }
                  }
                  $r = _g;
                  return $r;
                })(this).join(",") +
                ")"
              );
            } else {
              return n;
            }
          }
          if (o instanceof Array) {
            let str = "[";
            s += "\t";
            let _g = 0;
            let _g1 = o.length;
            while (_g < _g1) {
              let i = _g++;
              str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i], s);
            }
            str += "]";
            return str;
          }
          let tostr;
          try {
            tostr = o.toString;
          } catch (_g) {
            return "???";
          }
          if (
            tostr != null &&
            tostr != Object.toString &&
            typeof tostr == "function"
          ) {
            let s2 = o.toString();
            if (s2 != "[object Object]") {
              return s2;
            }
          }
          let str = "{\n";
          s += "\t";
          let hasp = o.hasOwnProperty != null;
          let k = null;
          for (k in o) {
            if (hasp && !o.hasOwnProperty(k)) {
              continue;
            }
            if (
              k == "prototype" ||
              k == "__class__" ||
              k == "__super__" ||
              k == "__interfaces__" ||
              k == "__properties__"
            ) {
              continue;
            }
            if (str.length != 2) {
              str += ", \n";
            }
            str += s + k + " : " + js_Boot.__string_rec(o[k], s);
          }
          s = s.substring(1);
          str += "\n" + s + "}";
          return str;
        case "string":
          return o;
        default:
          return String(o);
      }
    }
  }

  js_Boot.__name__ = true;
  class utils_Fn {
    static proto(obj) {
      return obj.prototype;
    }
    static updateProto(obj, fn) {
      return fn(obj.prototype);
    }
    static updateEntity(obj, fn) {
      return fn(obj);
    }
  }

  utils_Fn.__name__ = true;
  function $getIterator(o) {
    if (o instanceof Array) return new haxe_iterators_ArrayIterator(o);
    else return o.iterator();
  }
  var $_;
  function $bind(o, m) {
    if (m == null) return null;
    if (m.__id__ == null) m.__id__ = $global.$haxeUID++;
    var f;
    if (o.hx__closures__ == null) o.hx__closures__ = {};
    else f = o.hx__closures__[m.__id__];
    if (f == null) {
      f = m.bind(o);
      o.hx__closures__[m.__id__] = f;
    }
    return f;
  }
  $global.$haxeUID |= 0;
  String.__name__ = true;
  Array.__name__ = true;
  js_Boot.__toStr = {}.toString;
  LunaChatter.ChatterEmitter = new PIXI.utils.EventEmitter();
  LunaChatter.params = (function ($this) {
    var $r;
    let _this = $plugins;
    let _g = [];
    {
      let _g1 = 0;
      while (_g1 < _this.length) {
        let v = _this[_g1];
        ++_g1;
        if (new EReg("<LunaChatter>", "ig").match(v.description)) {
          _g.push(v);
        }
      }
    }
    $r = _g[0].parameters;
    return $r;
  })(this);
  LunaChatter.chatterQueue = [];
  LunaChatter.chatterWindows = [];
  LunaChatter.main();
})(
  typeof exports != "undefined"
    ? exports
    : typeof window != "undefined"
    ? window
    : typeof self != "undefined"
    ? self
    : this,
  typeof window != "undefined"
    ? window
    : typeof global != "undefined"
    ? global
    : typeof self != "undefined"
    ? self
    : this
);
