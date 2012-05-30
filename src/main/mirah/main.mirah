package net.savagerealms.savagegames

import java.util.logging.Level
import java.util.ArrayList

import org.bukkit.plugin.java.JavaPlugin

import com.onarandombox.MultiverseCore.api.MVPlugin

# Main plugin class.
class SavageGames < JavaPlugin
  # Accessors
  def self.i; @@i; end
  def invs; @inventoryKeeper; end
  def games; @gameManager; end
  def mv; @mv; end

  def onEnable
    @@i = self

    # Multiverse
    plugin = getServer.getPluginManager.getPlugin 'Multiverse-Core'
    unless plugin != null
      getLogger.log Level.SEVERE, 'Multiverse not found! Disabling plugin.'
      getServer.getPluginManager.disablePlugin self
    end

    begin
      @mv = MVPlugin(plugin)
    rescue Exception => ex
      getLogger.log Level.SEVERE, 'Multiverse not found! Disabling plugin.'
      getServer.getPluginManager.disablePlugin self
    end

    # Inventory keeper
    @inventoryKeeper = InventoryKeeper.new

    # Game manager
    @gameManager = GameManager.new self

    # Event listener
    @eventListener = SGListener.new self
    getServer.getPluginManager.registerEvents @eventListener, self

    # We're loaded!
    getLogger.log Level.INFO, "Let the SavageGames begin!"
  end

  def onDisable
    @@i = nil

    getLogger.log Level.INFO, "SavageGames disabled."
  end

end
