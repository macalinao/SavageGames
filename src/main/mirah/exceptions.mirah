package net.savagerealms.savagegames

##
# An exception thrown by SavageGames.
class SGException < Exception

  ##
  # Initializes the exception with the given error message.
  #
  def initialize(error:String)
    super error
  end
end
