package net.savagegames.savagegames

import spock.lang.*

import org.bukkit.Location
import org.bukkit.World
import org.bukkit.entity.Player

import org.bukkit.event.entity.EntityDamageEvent
import org.bukkit.event.entity.EntityDamageByEntityEvent

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

        main.games() >> games
        games.get_game_of_player(_) >> game
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
