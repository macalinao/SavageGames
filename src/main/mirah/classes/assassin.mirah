package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack
import org.bukkit.ChatColor

import org.bukkit.event.block.Action

import org.bukkit.event.player.PlayerInteractEvent

##
# The Assassin class.
#
class Assassin < SClass
  def self.i; @@i; end

  def initialize
    super 'Assassin'
    @@i = self
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.GHAST_TEAR, 1)
    player.getInventory.addItem items
  end

  def player_interact(event:PlayerInteractEvent):void
    action = event.getAction
    unless event.getAction.equals(Action.RIGHT_CLICK_AIR) or event.getAction.equals(Action.RIGHT_CLICK_BLOCK)
      return
    end

    unless event.getItem.getType.equals Material.GHAST_TEAR
      return
    end

    player = event.getPlayer

    game = SavageGames.i.games.get_game_of_player player
    if game == nil
      return
    end

    player.sendMessage ChatColor.GRAY.toString + 'You are now hidden.'
    hide_player player

    game.start_delayed_task "class_assassin_show_#{player.getName}", AssassinShowTask.new(player), 400 # 20 secs
  end

  def entity_damage(player:Player, event:EntityDamageEvent):void
    
  end

  ##
  # Hides the given player.
  #
  def hide_player(player:Player)
    game = SavageGames.i.games.get_game_of_player player
    game.players.each do |p|
      pl = Player(p)
      pl.hidePlayer player
    end
  end

  ##
  # Shows the given player again.
  #
  def show_player(player:Player)
    game = SavageGames.i.games.get_game_of_player player
    game.players.each do |p|
      pl = Player(p)
      pl.showPlayer player
    end
  end

  ##
  # Shows the assassin.
  #
  class AssassinShowTask < GameTask
    def player; @player; end

    def initialize(player:Player)
      @player = player
    end  

    def run:void
      Assassin.i.show_player player
    end
  end
end
