require 'chingu'
require 'ashton'
include Gosu
include Chingu

require_rel 'game_objects/*'
require_rel 'levels/*'

def media_path(file); File.expand_path "media/#{file}", File.dirname(__FILE__) end

class MainWindow < Chingu::Window
  def initialize
    super 1280, 768, false
    Gosu::enable_undocumented_retrofication
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