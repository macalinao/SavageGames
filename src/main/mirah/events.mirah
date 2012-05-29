package net.savagerealms.savagegames

import org.bukkit.Bukkit
import org.bukkit.event.Event
import org.bukkit.event.HandlerList
import org.bukkit.event.Cancellable

import org.bukkit.entity.Player

###################
# EVENT FACTORY
###################

class EventFactory
  def self.callGameModeChange(game:Game, mode:String)
    event = SGGameModeChangeEvent.new game, mode
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

class SGGameEvent < SGEvent
  """Represents an event happening with a game."""
  def game; @game; end # It's final!

  def initialize(game:Game)
    @game = game
  end
end

class SGGameModeChangeEvent < SGGameEvent
  """Called when a game's mode changes."""
  def mode; @mode; end

  def self.initialize
    @@handlers = HandlerList.new
  end

  def initialize(game:Game, mode:String)
    super(game)
    @mode = mode
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

class SGGamePlayerEvent < SGGameEvent
  """Events relating to both players and games."""

  def player; @player; end

  def self.initialize
    @@handlers = HandlerList.new
  end

  def initialize(game:Game, player:Player)
    super(game)
    @player = player
  end
end

class SGGamePlayerBorderEvent < SGGamePlayerEvent
  implements Cancellable
  """Called when a player attempts to cross the border of a game."""

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

# Don't worry about it
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
