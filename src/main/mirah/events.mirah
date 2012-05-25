package net.savagerealms.savagegames.event

import org.bukkit.event.Event
import org.bukkit.event.HandlerList

class SGEvent < Event
end

class SavageBreakEvent < SGEvent

  def self.initialize
    @@handlers = HandlerList.new
  end

  def initialize

  end

  def getHandlers
    @@handlers
  end

  def self.getHandlerList
    @@handlers
  end

end
