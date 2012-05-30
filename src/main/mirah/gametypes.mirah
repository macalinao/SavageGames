package net.savagerealms.savagegames

##
# Represents a type of game characterized by a map and its behaviors.
#
class GameType
  ##
  # Sets up the GameType.
  def setup():void; end
end

##
# Represents a GameType using a map generator.
# Utilizes the power of Multiverse.
#
class MultiverseGameType < GameType

  ##
  # Initializes the GameType.
  def initialize(main:SavageGames)
    @main = main
  end

  def setup()
    wm = @main.mv.getCore.getMVWorldManager
    return
  end
end

"""
class TCGameType < GameType
  def initialize(config:WorldConfig)
    
  end

  def setup()

  end
end
"""
