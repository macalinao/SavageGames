package net.savagegames.savagegames

##
# Class that handles command logic.
#
class Commands

  ##
  # Registers all commands.
  #
  def self.register_all(main:SavageGames)
    main.getCommand('class').setExecutor ClassCommand.new
  end

end
