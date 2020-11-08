import rm.sprites.Sprite_Character;
import rm.objects.Game_Event;

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
}
