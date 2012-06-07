package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.entity.Zombie

import org.bukkit.event.entity.EntityDamageByEntityEvent

##
# The Slayer class.
#
class Slayer < SClass
  def self.i; @@i; end

  def initialize
    super 'Slayer'
    @@i = self
  end

  def entity_damage_by_entity(event:EntityDamageByEntityEvent):void
    damager = Player(event.getDamager)

    game = SavageGames.i.games.get_game_of_player damager
    if game == nil
      return
    end

    tar = event.getEntity
    unless tar.kind_of? Zombie
      return
    end
    target = Zombie(tar)
    target.setHealth 1
  end
end
