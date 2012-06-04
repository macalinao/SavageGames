package net.savagegames.savagegames

##
# Updates all compasses when run.
#
class CompassTask
  implements Runnable

  def compasses; @compasses; end

  def initialize(compasses:CompassUpdater)
    @compasses = compasses
  end

  def run:void
    compasses.update_all
  end
end
