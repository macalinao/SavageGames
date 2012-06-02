package net.savagegames.savagegames

import spock.lang.*

class GameSpec extends Specification {

    GameType type
    Game game    

    def setup() {
        type = Mock()
        game = new Game(type)
    }

    def "next_phase should advance the phase"() {
        given:
        GamePhase phase = Mock()
        game.phase_set phase

        GamePhase next = Mock()
        phase.next() >> next

        when: "do next_phase"
        game.next_phase()

        then: "the phase should be the next phase"
        game.phase() == next

        and: "the next phase should have began"
        1 * next.begin(game)
    }
}
