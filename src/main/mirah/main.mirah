package net.savagerealms.savagegames.savagegames

import org.bukkit.plugin.java.JavaPlugin
import java.util.logging.Level

class SavageGames < JavaPlugin

  def onEnable
    getLogger().log Level.INFO, "Let the SavageGames begin!"
  end

  def onDisable
    getLogger().log Level.INFO, "SavageGames disabled."
  end

end