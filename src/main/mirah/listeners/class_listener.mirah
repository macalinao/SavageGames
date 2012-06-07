package net.savagegames.savagegames

import org.bukkit.entity.Player

import org.bukkit.event.Listener
import org.bukkit.event.EventHandler

import org.bukkit.event.entity.EntityDamageEvent
import org.bukkit.event.entity.EntityDamageByEntityEvent

import org.bukkit.event.player.PlayerInteractEvent

##
# Listens to class-related events.
#
class ClassListener
  implements Listener
  
  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

  $EventHandler
  def onPlayerInteract(event:PlayerInteractEvent):void
    player = event.getPlayer
    clazz = main.classes.get_class_of_player player

    if clazz != nil 
      if clazz.is 'chef'
        Chef.i.player_interact event
      elsif clazz.is 'ghost'
        Assassin.i.player_interact event
      end
    end
  end

  $EventHandler
  def onEntityDamage(event:EntityDamageEvent):void
    if event.kind_of? EntityDamageByEntityEvent
      ede = EntityDamageByEntityEvent(event)

      if ede.getDamager.kind_of? Player
        damager_player = Player(ede.getDamager)

        clazz = main.classes.get_class_of_player damager_player

        if clazz != nil
          if clazz.is 'assassin'
            Assassin.i.entity_damage_by_entity ede
          end
        end
      end
    end
  end
end
