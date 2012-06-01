package net.savagegames.savagegames

import org.bukkit.entity.Player

##
# Routes players who join to the correct lobby.
#
class PlayerRouter
  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

  ##
  # Sets up the router.
  #
  def setup:void; end

  ##
  # Routes the player to where they should be.
  #
  # This is for login or after a game ends.
  #
  def route(player:Player):void; end

  ##
  # Routes a player after they die in a game.
  #
  def route_death(player:Player, game:Game):void; end
end
