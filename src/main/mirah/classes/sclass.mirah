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
end
