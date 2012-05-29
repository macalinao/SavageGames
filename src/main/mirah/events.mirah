package net.savagerealms.savagegames

import org.bukkit.Bukkit
import org.bukkit.event.Event
import org.bukkit.event.HandlerList
import org.bukkit.event.Cancellable


###################
# EVENT FACTORY
###################

class EventFactory
  def self.callGameModeChange(game:Game, mode:String)
    event = SGGameModeChangeEvent.new game, mode
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

###################
# GAME EVENTS
###################

class SGGameEvent < SGEvent
  def game; @game; end # It's final!

  def initialize(game:Game)
    @game = game
  end
end

# Called when a game's mode changes.
class SGGameModeChangeEvent < SGGameEvent
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
