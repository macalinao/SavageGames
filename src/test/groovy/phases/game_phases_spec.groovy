package net.savagegames.savagegames

import spock.lang.*

class GamePhasesSpec extends Specification {
    def "game phases are in order"() {
        expect:
        GamePhases.after(GamePhases.Lobby()) == GamePhases.Diaspora()
        GamePhases.after(GamePhases.Diaspora()) == GamePhases.Main()
        GamePhases.after(GamePhases.Main()) == GamePhases.Feast()
        GamePhases.after(GamePhases.Feast()) == null
    }

    def "with diaspora and main, main is last"() {
        expect:
        GamePhases.last(GamePhases.Diaspora(), GamePhases.Main()) == GamePhases.Main()
    }

    def "with feast and main, feast is last"() {
        expect:
        GamePhases.last(GamePhases.Feast(), GamePhases.Main()) == GamePhases.Feast()
    }

    def "with lobby and lobby, lobby is last"() {
        expect:
        GamePhases.last(GamePhases.Lobby(), GamePhases.Lobby()) == GamePhases.Lobby()
    }
}