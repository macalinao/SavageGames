package net.savagegames.savagegames

import org.bukkit.entity.Player

class SClass
  def name():String; @name; end

  def initialize(name:String)
    @name = name
  end

  ##
  # Called when the game starts.
  #
  def bind(player:Player):void; end

  ##
  # Returns true if the class name is identified by given.
  #
  def is(n:String)
    return name.toLowerCase.equals n.toLowerCase
  end
end
