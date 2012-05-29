package net.savagerealms.savagegames

import java.util.logging.Level
import java.util.ArrayList

import org.bukkit.plugin.java.JavaPlugin

# Main plugin class.
class SavageGames < JavaPlugin
  # Accessors
  def self.i; @@i; end
  def invs; @inventoryKeeper; end
  def games; @gameManager; end

  def onEnable
    @@i = self

    # Inventory keeper
    @inventoryKeeper = InventoryKeeper.new

    # Game manager
    @gameManager = GameManager.new self

    # We're loaded!
    getLogger.log Level.INFO, "Let the SavageGames begin!"
  end

  def onDisable
    @@i = nil

    getLogger.log Level.INFO, "SavageGames disabled."
  end

end
