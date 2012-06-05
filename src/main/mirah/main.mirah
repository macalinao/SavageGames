package net.savagegames.savagegames

import java.util.logging.Level
import java.util.ArrayList

import org.bukkit.World
import org.bukkit.plugin.java.JavaPlugin

import com.onarandombox.MultiverseCore.api.MVPlugin

# Main plugin class.
class SavageGames < JavaPlugin
  # Accessors
  def self.i; @@i; end
  def invs; @inventoryKeeper; end
  def games; @gameManager; end
  def mv; @mv; end
  def router; @router; end
  def classes; @classes; end
  def compasses; @compasses; end

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

    # Player router
    @router = PlayerRouter(nil)
    @router = SingleGamePlayerRouter.new self

    # Inventory keeper
    @inventoryKeeper = InventoryKeeper.new

    # Game manager
    @gameManager = GameManager.new self

    # Classes
    @classes = ClassManager.new

    # Compasses
    @compasses = CompassUpdater.new self

    # Event listener
    @event_listener = SGListener.new self
    getServer.getPluginManager.registerEvents @event_listener, self

    @class_listener = ClassListener.new self
    getServer.getPluginManager.registerEvents @class_listener, self

    # Start routing
    router.setup

    # Register commands
    Commands.register_all self

    # We're loaded!
    getLogger.log Level.INFO, "Let the SavageGames begin!"
  end

  def onDisable
    @@i = nil

    getLogger.log Level.INFO, "SavageGames disabled."
  end

end
