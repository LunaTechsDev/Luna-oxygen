import rm.types.RPG.BaseItem;
import rm.objects.Game_Party;

class GameParty extends Game_Party {
  public override function gainItem(item: BaseItem, amount: Int, includeEquip: Bool) {
    // super.gainItem(item, amount, includeEquip);
    untyped _Game_Party_gainItem.call(this, item, amount, includeEquip);
    Main.pushItemNotif(item, amount);
  }

  public override function loseItem(item: BaseItem, amount: Int, includeEquip: Bool) {
    // super.loseItem(item, amount, includeEquip);
    untyped _Game_Party_loseItem.call(this, item, amount, includeEquip);
    trace('Lose Item amount', amount);
    Main.pushItemNotif(item, amount);
  }
}
