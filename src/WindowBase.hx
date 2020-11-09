import rm.types.RM.TextState;
import rm.windows.Window_Base;
import ChatterExtensions;

class WindowBase extends Window_Base {
  public override function processEscapeCharacter(code: String, textState: TextState) {
    switch (code) {
      case 'LCT':
        ChatterExtensions.processTemplateString(this, cast this.obtainEscapeParam(textState), textState);
      case 'LCJS':
        ChatterExtensions.processJSTemplateString(this, cast this.obtainEscapeParam(textState), textState);
      case _:
        untyped _Window_Base_processEscapeCharacter.call(this, code, textState);
    }
  }
}
