package net.savagegames.savagegames

import java.util.HashMap

class PlayerSession
  def map; @map; end
  def player; @player; end

  def initialize(player:String)
    @map = HashMap.new
    @player = player
  end

  ##
  # Gets an object.
  #
  def get(key:String):Object
    return map.get key
  end

  ##
  # Gets a boolean.
  #
  def get_boolean(key:String):boolean
    val = get key
    if val != null
      begin
        return Boolean(val).booleanValue
      rescue Exception
        return false
      end
    end
    return false
  end

  ##
  # Gets a long.
  #
  def get_long(key:String):long
    val = get key
    if val != null
      begin
        return Long(val).longValue
      rescue Exception
        return long(0)
      end
    end
    return long(0)
  end

  ##
  # Sets something to a given value.
  #
  def set(key:String, value:Object):void
    map.put key, value
  end

  ##
  # Unsets a value.
  #
  def unset(key:String)
    map.remove key
  end
end
