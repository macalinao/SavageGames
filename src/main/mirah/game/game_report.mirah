package net.savagegames.savagegames

import java.util.ArrayList

import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONStringer

class GameReport
  def rankings:ArrayList; @rankings; end

  def initialize(game_size:Integer)
    @type = 'Vanilla' # Todo
    @date = System.currentTimeMillis
    @game_size = game_size
    @rankings = ArrayList.new
  end

  def push_ranking(ranking:Ranking):void
    ranking.rank = rankings.size - @game_size.intValue
    rankings.add ranking
  end

  $Override
  def toString:String
    rootNode = JSONObject.new
    rootNode.put 'secret', SavageGames.i.secret
    rootNode.put 'type', @type
    rootNode.put 'date', @date

    rankingsNode = JSONArray.new
    rankings.each do |obj|
      rankingNode = JSONObject.new
      ranking = Ranking(obj)
      rankingNode.put 'time', ranking.time
      rankingNode.put 'player', ranking.player
      rankingNode.put 'kills', JSONArray.new(ranking.kills)
      rankingNode.put 'class', ranking.clazz
      rankingNode.put 'rank', ranking.rank
      rankingsNode.put rankingNode
    end

    rootNode.put 'rankings', rankingsNode

    return rootNode.toString
  end
end

class Ranking
  def initialize
    @kills = ArrayList.new
  end

  def time; @time; end
  def time=(time:int); @time = time; end

  def player; @player; end
  def player=(player:String); @player = player; end

  def kills; @kills; end

  def clazz; @clazz; end
  def clazz=(clazz:String); @clazz = clazz; end

  def rank; @rank; end
  def rank=(rank:int); @rank = rank; end
end
