package net.savagegames.savagegames

import java.util.Map
import java.util.HashMap

import org.bukkit.entity.Player

class CompassUpdater
  def main; @main; end
  def targets; @targets; end

  ##
  # Initializes the compass updater.
  #
  def initialize(main:SavageGames)
    @main = main
    @targets = HashMap.new

    setup_task
  end

  ##
  # Sets up the compass update task.
  #
  def setup_task:void
    main.getServer.getScheduler.scheduleSyncRepeatingTask main, \
      CompassTask.new(self), 0, 20 # Update compasses every second
  end

  ##
  # Sets the target of the given player's compass to the given target player.
  #
  def set_target(player:Player, target:Player):void
    targets.put player, target
  end

  ##
  # Updates the given player's compass target.
  #
  def update_target(player:Player):void
    tar = targets.get player
    if tar == nil
      return
    end

    player.setCompassTarget Player(tar).getLocation
  end

  def remove_target_of(player:Player):void
    player.setCompassTarget player.getLocation
    targets.remove player
  end

  ##
  # Updates the targets of all players.
  #
  def update_all:void
    targets.keySet.each do |t|
      player = Player(t)

      update_target player
    end
  end
end
