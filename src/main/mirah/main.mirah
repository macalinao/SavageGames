package net.savagerealms.savagegames

import java.util.logging.Level
import java.util.ArrayList

import org.bukkit.plugin.java.JavaPlugin

import com.sk89q.worldedit.bukkit.WorldEditPlugin

# Main plugin class.
class SavageGames < JavaPlugin
  # Accessors
  def self.i; @@i; end
  def worldEdit; @worldEdit; end

  def onEnable
    @@i = self

    # Load WorldEdit
    worldEdit = getServer.getPluginManager.getPlugin "WorldEdit"
    if worldEdit.kind_of?(WorldEditPlugin)
      @worldEdit = WorldEditPlugin(worldEdit)
    else
      getLogger.log Level.SEVERE, "WorldEdit not found! This plugin is being disabled."
      Bukkit.getPluginManager.disablePlugin(self)
    end

    # We're loaded!
    getLogger.log Level.INFO, "Let the SavageGames begin!"
  end

  def onDisable
    getLogger.log Level.INFO, "SavageGames disabled."
  end

end
