package net.savagegames.savagegames

import java.util.HashSet

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack
import org.bukkit.ChatColor
import org.bukkit.Bukkit

import org.bukkit.event.block.Action

import org.bukkit.event.entity.EntityDamageByEntityEvent
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

    last = get_last_hide player
    unless last == 0
      elapsed = System.currentTimeMillis - last
      if elapsed < 1000 * 180 # 3 minutes
        secs = elapsed / 1000
        player.sendMessage ChatColor.RED.toString + "There are #{secs} seconds remaining until you can use this ability again."
        return
      end
    end

    player.sendMessage ChatColor.GRAY.toString + 'You are now hidden.'
    hide_player player

    game.start_delayed_task "class_assassin_show_#{player.getName}", AssassinShowTask.new(player), 400 # 20 secs
  end

  def entity_damage_by_entity(event:EntityDamageByEntityEvent):void
    damager = Player(event.getDamager)

    game = SavageGames.i.games.get_game_of_player damager
    if game == nil
      return
    end

    tar = event.getEntity
    unless tar.kind_of? Player
      return
    end
    target = Player(tar)
    
    target.sendMessage ChatColor.RED.toString + "You've been ambushed by an assassin!"
    show_player damager

    game.cancel_task "class_assassin_show_#{damager.getName}"
  end

  ##
  # Hides the given player.
  #
  def hide_player(player:Player):boolean
    session = SavageGames.i.sessions.get_session_of_player player
    if session.get_boolean 'assassin_hidden'
      return false
    end

    game = SavageGames.i.games.get_game_of_player player
    game.players.each do |p|
      pl = Bukkit.getPlayer p
      if pl == nil
        next
      end
      pl.hidePlayer player
    end

    session.set 'assassin_hidden', Boolean.TRUE
    set_last_hide player, System.currentTimeMillis
    return true
  end

  ##
  # Shows the given player again.
  #
  def show_player(player:Player):boolean
    session = SavageGames.i.sessions.get_session_of_player player
    unless session.get_boolean 'assassin_hidden'
      return false
    end

    game = SavageGames.i.games.get_game_of_player player
    game.players.each do |p|
      pl = Player(p)
      pl.showPlayer player
    end

    session.unset 'assassin_hidden'
    return true
  end

  ##
  # Gets the last hide time.
  #
  def get_last_hide(player:Player):long
    session = SavageGames.i.sessions.get_session_of_player player
    return session.get_long 'assassin_last_hide'
  end

  ##
  # Sets the last hide time.
  #
  def set_last_hide(player:Player, time:long):void
    session = SavageGames.i.sessions.get_session_of_player player
    session.set 'assassin_last_hide', Long.valueOf(time)
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
