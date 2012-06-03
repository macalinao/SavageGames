package net.savagegames.savagegames

import org.bukkit.event.Listener

##
# Listens to class-related events.
#
class ClassListener
  implements Listener
  
  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

end
