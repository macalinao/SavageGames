package net.savagegames.savagegames

import java.util.Random

import org.bukkit.entity.Player

import org.bukkit.potion.PotionEffect
import org.bukkit.potion.PotionEffectType

##
# The Loner class.
#
class Loner < SClass
  def initialize
    super 'Loner'
  end

  def bind(player:Player)
    # Find random spot
    game = SavageGames.i.games.get_game_of_player player

    hdimx = game.type.dimx / 2
    hdimz = game.type.dimz / 2

    rand = Random.new System.currentTimeMillis

    xa = rand.nextInt 60
    za = rand.nextInt 60

    mdimx = hdimx - xa
    mdimz = hdimz - za

    dax = 0
    daz = 0

    if rand.nextBoolean
      daz = mdimz
    else
      dax = -mdimx
    end

    if rand.nextBoolean
      dax = mdimx
    else
      daz = -mdimz
    end

    center = game.type.spawn
    loc = center.add dax, 0, daz
    loc = loc.getWorld.getHighestBlockAt(loc).getLocation

    player.teleport loc
  end
end
