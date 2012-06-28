package net.savagegames.savagegames

import org.bukkit.Bukkit
import org.bukkit.entity.Player

import java.net.URL
import java.io.OutputStreamWriter
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.logging.Level

##
# The main phase of the game.
#
# This is where a lot of people die.
#
class WinPhase < GamePhase

  def enter(game:Game)
    if game.players.size <= 0
      game.next_phase
    end

    player = game.players.get(0)
    pl = Bukkit.getPlayer player.toString
    pl.kickPlayer "Congrats! You've won! The server will be back up in about a minute."
    game.remove_player player.toString

    report = game.report.toString
    puts report

    begin
        url = URL.new "http://savagegames.net/reports"
        conn = url.openConnection
        conn.setDoOutput true
        conn.setRequestProperty 'Content-Type', 'application/json'

        wr = OutputStreamWriter.new conn.getOutputStream

        wr.write report
        wr.flush

        rd = BufferedReader.new InputStreamReader.new conn.getInputStream
        String line = ''
        String response = ''
        while ((line = rd.readLine()) != null)
          response += line
        end

        puts response + "\n"

        wr.close
        rd.close
    rescue Exception => ex
      SavageGames.i.getLogger.log Level.INFO, 'Error when posting results to the HIVE!', ex
    end

    Bukkit.getServer.shutdown
  end

  def exit(game:Game)
  end

  def should_progress?(game:Game):boolean
    return true
  end
end
