package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.inventory.ItemStack
import org.bukkit.Material

import java.util.ArrayList
import java.util.HashMap

##
# Manages classes.
#
class ClassManager
  ##
  # Initialize.
  #
  def initialize
    @classes = HashMap.new
    @player_classes = HashMap.new

    setup_classes
  end

  ##
  # Gets the class with the given name.
  #
  def get_class(name:String):SClass
    return SClass(@classes.get name.toLowerCase)
  end

  ##
  # Adds the class.
  #
  def add_class(clazz:SClass):void
    @classes.put clazz.name.toLowerCase, clazz
  end

  ##
  # Sets the class of the given player to the given class.
  #
  def set_class_of_player(player:Player, clazz:SClass):void
    @player_classes.put player, clazz
  end

  ##
  # Gets the class of the given player.
  #
  def get_class_of_player(player:Player):SClass
    c = @player_classes.get player
    return nil if c == nil
    return SClass(c)
  end

  ##
  # Resets the class of the given player to nothing.
  #
  def reset_class_of_player(player:Player):void
    @player_classes.remove player
  end

  ##
  # Gets a list of all classes.
  #
  def list
    return ArrayList.new @classes.values
  end

  ##
  # Gets a list of available classes to a player in String format.
  #
  def list_classes_available(player:Player):String
    response = ''

    first = true

    list.each do |c|
      clazz = SClass(c)
      unless first
        response += ', ' + clazz.name
      else
        first = false
        response += clazz.name
      end
    end

    return response.trim
  end

  private
  def setup_classes
    add_class Arsonist.new
    add_class Assassin.new
    add_class Chef.new
    add_class Diver.new
    add_class Excavator.new
    add_class Firefighter.new
    add_class Fisherman.new
    add_class Herbalist.new
#    add_class Loner.new
    add_class Miner.new
    add_class Nightcrawler.new
    add_class Rabbit.new
    add_class Ranger.new
    add_class Slayer.new
    add_class Warrior.new
    add_class Yeti.new
  end
end
