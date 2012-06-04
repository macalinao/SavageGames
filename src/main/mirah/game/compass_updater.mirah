package net.savagegames.savagegames

import org.bukkit.entity.Player

class CompassUpdater
  ##
  # Initializes the compass updater.
  #
  def initialize
    @targets = HashMap.new
  end  

  ##
  # Sets the target of the given player's compass to the given target player.
  #
  def set_target(player:Player, target:Player):void
    @targets.put player, target
  end

  ##
  # Updates the given player's compass target.
  #
  def update_target(player:Player)
    tar = @targets.get player
    if tar == nil
      return
    end

    player.setCompassLocation tar.getLocation
  end
end
