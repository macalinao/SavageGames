package net.savagegames.savagegames

import java.util.HashMap

import org.bukkit.entity.Player
import org.bukkit.inventory.ItemStack

# Keeps inventories persisted.
class InventoryKeeper
  # Init some stuff
  def initialize
    @inventories = HashMap.new
  end

  # Saves the inventory of the given player.
  def saveInvOf(p:Player)
    store = PlayerInventories.new

    store.main = p.getInventory.getContents
    store.armor = p.getInventory.getArmorContents

    @inventories.put p, store
  end

  # Retrieves the inventory of the given player.
  # TODO: should this persist?
  def retrieveInvOf(p:Player)
    inv = @inventories.get p
    PlayerInventories(inv)
  end

  # Frees the inventory of the given player from memory.
  def freeInvOf(p:Player)
    @inventories.remove p
  end

  # Restores the inventory of the given player.
  def restoreInvOf(p:Player)
    inv = retrieveInvOf p
    return false if inv == nil
    clearInvOf p

    p.getInventory.setContents inv.main
    p.getInventory.setArmorContents inv.armor

    freeInvOf p
    p.updateInventory
    return true
  end

  # Clears the inventory of the given player.
  def clearInvOf(p:Player)
    # Remove main inv
    inv = p.getInventory.getContents
    inv.length.times {|i|
      inv[i] = null
    }
    p.getInventory.setContents inv

    # Remove armor inv
    ainv = p.getInventory.getArmorContents
    ainv.length.times {|i|
      ainv[i] = null
    }
    p.getInventory.setArmorContents ainv

    p.updateInventory
  end

end

class PlayerInventories
  def main; @main; end
  def main=(stacks:ItemStack[]):void; @main = stacks; end

  def armor; @armor; end
  def armor=(stacks:ItemStack[]):void; @armor = stacks; end
end