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

    setup_classes
  end

  private
  def setup_classes
    add_class Warrior.new
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
  # Gets a list of all classes.
  #
  def list
    return ArrayList.new @classes.values
  end
end
