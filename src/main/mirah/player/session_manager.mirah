package net.savagegames.savagegames

import java.util.HashMap

class SessionManager
  def sessions; @sessions; end

  def initialize
    @sessions = HashMap.new
  end

  ##
  # Gets the session of the given player.
  #
  def get_session_of_player(player:Player):PlayerSession
    return get_session player.getName
  end

  ##
  # Gets the session of a player.
  #
  def get_session(player:String):PlayerSession
    session = PlayerSession(nil)

    obj = sessions.get player
    if obj == nil
      session = PlayerSession.new player
      sessions.put player, session
    else
      session = PlayerSession(obj)
    end
    return session
  end

  ##
  # Clears the session of the given player.
  #
  def clear_session_of_player(player:Player):void
    clear_session player.getName
  end

  ##
  # Clears the session of the given player.
  #
  def clear_session(player:String):void
    sessions.remove player
  end
end
