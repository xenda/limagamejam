require 'chingu'
require 'ashton'
require 'bundler/setup' # Releasy requires require that your application uses bundler.
require 'releasy'

include Gosu
include Chingu

require_rel 'game_objects/*'
require_rel 'levels/*'

def media_path(file); File.expand_path "media/#{file}", File.dirname(__FILE__) end

class MainWindow < Chingu::Window
  def initialize
    super 1000, 550, false
    # Gosu::enable_undocumented_retrofication
    self.caption = "Matusita"
    # self.factor = 2

    # retrofy rescue nil

    self.input = {
      :escape => :exit
    }
  end

  def setup
    # retrofy
    switch_game_state(Level0)
  end

end

MainWindow.new.show