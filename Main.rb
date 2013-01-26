require 'gosu'
require 'ashton'

def media_path(file); File.expand_path "media/#{file}", File.dirname(__FILE__) end

class MainWindow < Gosu::Window
  def initialize
    super 1024, 768, false
    self.caption = "BloodStuff"
    @font = Gosu::Font.new self, Gosu::default_font_name, 40
    @background = Gosu::Image.new(self, media_path("background.jpg"), true)
  end

  def needs_cursor?; true end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def draw
    @background.draw 0, 0, 0, width.fdiv(@background.width), height.fdiv(@background.height)
    @font.draw_rel "WELCOME~", width / 2, height / 2, 0, 0, 0.5
  end
end

MainWindow.new.show
