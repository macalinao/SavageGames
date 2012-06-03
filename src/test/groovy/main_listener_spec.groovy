package net.savagegames.savagegames

import spock.lang.*

import java.util.ArrayList

import org.bukkit.Location
import org.bukkit.World
import org.bukkit.entity.Player

import org.bukkit.event.entity.EntityDamageEvent
import org.bukkit.event.entity.EntityDamageByEntityEvent
import org.bukkit.event.entity.EntityDeathEvent

import org.bukkit.event.player.PlayerMoveEvent

class SGListenerSpec extends Specification {

    SavageGames main
    SGListener listener
    Game game
    GameManager games

    def setup() {
        main = Mock()
        listener = new SGListener(main)
        game = Mock()
        games = Mock()

        PlayerRouter router = Mock()

        main.router() >> router
        main.games() >> games
        games.get_game_of_player(_) >> game
    }

    def "when a player dies ingame, they are routed and lightning strikes"() {
        given:
        def event = Mock(EntityDeathEvent)
        def player = Mock(Player)

        event.getEntity() >> player

        def pLoc = Mock(Location)
        def pWorld = Mock(World)

        player.getLocation() >> pLoc
        pLoc.getWorld() >> pWorld

        def players = Mock(ArrayList)
        players.size() >> 100
        game.players() >> players

        def type = Mock(GameType)
        type.feast_players() >> 10
        game.type() >> type

        when: "The player dies ingame"
        listener.onEntityDeath event

        then: "The player should be routed"
        1 * main.router().route_death(player, game)

        and: "lightning should strike"
        1 * pWorld.strikeLightningEffect(pLoc)
    }

    def "the event is cancelled if a player gets damaged in the lobby"() {
        given:
        def event = Mock(EntityDamageEvent)
        def player = Mock(Player)

        event.getEntity() >> player
        game.phase() >> GamePhases.Lobby()

        when: "The player is damaged"
        listener.onEntityDamage event

        then: "The event should be cancelled"
        1 * event.setCancelled(true)
    }

    def "the event is cancelled if a player gets damaged by another player in diaspora"() {
        given:
        def event = Mock(EntityDamageByEntityEvent)
        def player = Mock(Player)
        def enemy = Mock(Player)

        def pLoc = Mock(Location)
        def pWorld = Mock(World)

        player.getLocation() >> pLoc
        pLoc.getWorld() >> pWorld

        games.get_game(_) >> game
        event.getEntity() >> player
        event.getDamager() >> enemy
        game.phase() >> GamePhases.Diaspora()

        when: "The player is damaged"
        listener.onEntityDamage event

        then: "The event should be cancelled"
        1 * event.setCancelled(true)
    }

    def "the event is not cancelled if a player gets damaged in the diaspora not by another player"() {
        given:
        def event = Mock(EntityDamageEvent)
        def player = Mock(Player)

        event.getEntity() >> player
        game.phase() >> GamePhases.Diaspora()

        when: "The player is damaged"
        listener.onEntityDamage event

        then: "The event should be cancelled"
        (_..0) * event.setCancelled(true)
    }
}
