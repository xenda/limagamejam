require 'chingu'
require 'ashton'
include Gosu
include Chingu

require_rel 'game_objects/*'
require_rel 'levels/*'

def media_path(file); File.expand_path "media/#{file}", File.dirname(__FILE__) end

class MainWindow < Chingu::Window
  def initialize
    super 640, 480
    self.caption = "Matusita"

    self.input = {
      :escape => :exit
    }
  end

  def setup
    retrofy
    switch_game_state(Level1)
  end


end

MainWindow.new.show
