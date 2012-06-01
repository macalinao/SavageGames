package net.savagegames.savagegames

##
# A game task.
#
class GameTask
  implements Runnable

  def game; @game; end  
  def game=(game:Game); @game = game; end 
end
