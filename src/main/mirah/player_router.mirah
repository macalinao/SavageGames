package net.savagerealms.savagegames

import org.bukkit.entity.Player

##
# Routes players who join to the correct lobby.
#
interface PlayerRouter do
  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

  ##
  # Routes the player to where they should be.
  #
  # This is for login or after a game ends.
  #
  def route(player:Player); end

  ##
  # Routes a player after they die in a game.
  #
  def route_death(player:Player, game:Game); end
end

##
# Router for a single game server.
#
class SingleGamePlayerRouter
  implements PlayerRouter

  def initialize(main:SavageGames)
    super main
  end

  def route(player:Player)

  end

  def route_death(player:Player, game:Game)
    
  end
end
