package net.savagegames.savagegames

import java.io.File

class FileUtils
  def self.delete(f:File)
    if f.isDirectory
      f.listFiles.each do |file|
        self.delete File(file)
      end
    end

    f.delete
  end
end
`