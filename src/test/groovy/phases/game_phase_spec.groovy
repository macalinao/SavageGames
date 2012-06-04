package net.savagegames.savagegames

import spock.lang.*

class GamePhaseSpec extends Specification {
    def "next should give the next phase"() {
        expect:
        GamePhases.Lobby().next().equals GamePhases.Diaspora()
    }

    def "the last phase's next should be null"() {
        expect:
        GamePhases.Win().next() == null
    }

    def "lobby is not at least main"() {
        expect:
        GamePhases.Lobby().is_at_least(GamePhases.Main()) == false
    }

    def "main is at least lobby"() {
        expect:
        GamePhases.Main().is_at_least(GamePhases.Lobby()) == true
    }

}
