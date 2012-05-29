package net.savagerealms.savagegames

import java.io.File
import java.io.IOException
import java.util.HashMap
import java.util.logging.Level

import org.bukkit.Bukkit
import org.bukkit.configuration.file.YamlConfiguration

class GameManager
  def initialize(main:SavageGames)
    @main = main
    @arenas = HashMap.new
  end
end
