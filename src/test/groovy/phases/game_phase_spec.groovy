package net.savagegames.savagegames

import spock.lang.*

class GamePhaseSpec extends Specification {
    def "next should give the next phase"() {
        expect:
        GamePhases.Lobby().next().equals GamePhases.Diaspora()
    }

    def "the last phase's next should be null"() {
        expect:
        GamePhases.Feast().next() == null
    }
}
