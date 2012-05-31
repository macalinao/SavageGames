package net.savagegames.savagegames

import org.bukkit.Bukkit
import org.bukkit.event.Event
import org.bukkit.event.HandlerList
import org.bukkit.event.Cancellable

import org.bukkit.entity.Player

##
# Makes events.
#
class EventFactory
  def self.callGamePhaseChange(game:Game, phase:GamePhase)
    event = SGGamePhaseChangeEvent.new game, phase
    callEvent event
    event
  end

  def self.callGamePlayerBorderEvent(game:Game, player:Player)
    event = SGGamePlayerBorderEvent.new game, player
    callEvent event
    event
  end

  private
  def self.callEvent(event:Event)
    Bukkit.getPluginManager.callEvent event
  end
end

class SGEvent < Event
end

"""
GAME EVENTS
"""

##
# Represents an event happening within a game.
#
class SGGameEvent < SGEvent
  def game; @game; end # It's final!

  def initialize(game:Game)
    @game = game
  end
end

##
# Called when a game's phase changes.
#
class SGGamePhaseChangeEvent < SGGameEvent
  """Called when a game's phase changes."""
  def phase; @phase; end

  def self.initialize
    @@handlers = HandlerList.new
  end

  def initialize(game:Game, phase:GamePhase)
    super(game)
    @phase = phase
  end

  def getHandlers
    @@handlers
  end

  def self.getHandlerList
    @@handlers
  end
end

"""
GAME/PLAYER EVENTS
"""

##
# Event relating to both players and games.
#
class SGGamePlayerEvent < SGGameEvent
  def player; @player; end

  def self.initialize
    @@handlers = HandlerList.new
  end

  def initialize(game:Game, player:Player)
    super(game)
    @player = player
  end
end

##
# Called when a player attempts to cross the border of a game.
#
class SGGamePlayerBorderEvent < SGGamePlayerEvent
  implements Cancellable

  def self.initialize
    @@handlers = HandlerList.new
  end

  def initialize(game:Game, player:Player)
    super game, player
  end

  def isCancelled
    @cancelled
  end

  def setCancelled(cancel:boolean)
    @cancelled = cancel
  end

  def getHandlers
    @@handlers
  end

  def self.getHandlerList
    @@handlers
  end
end

###################
# TEST EVENTS
###################
##
# Don't worry about it
#
class SGSampleEvent < SGEvent
  implements Cancellable

  def self.initialize
    @@handlers = HandlerList.new
  end

  def initialize

  end

  def isCancelled
    @cancelled
  end

  def setCancelled(cancel:boolean)
    @cancelled = cancel
  end

  def getHandlers
    @@handlers
  end

  def self.getHandlerList
    @@handlers
  end

end
