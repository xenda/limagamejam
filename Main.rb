require 'chingu'
require 'ashton'
include Gosu
include Chingu

def media_path(file); File.expand_path "media/#{file}", File.dirname(__FILE__) end

class MainWindow < Chingu::Window
  def initialize
    super 640, 480
    self.caption = "Max Alvarez"
    @font = Gosu::Font.new self, Gosu::default_font_name, 40
  end

  def setup
    retrofy

    switch_game_state(Level1)
  end
end

class Level1 < Chingu::GameState

  traits :viewport, :timer

  def initialize(options = {})
    super(options)

    @parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @parallax << { :image => media_path("background.jpg"), :repeat_x => true, :repeat_y => true}

    self.input = {
      :escape => :close
    }

    @doctor = Doctor.create(:x => 100, :y => 440)

    self.viewport.game_area = [0, 0, 3200, 480]
  end

  def update
    super

    self.viewport.center_around(@doctor)

    @parallax.camera_x = self.viewport.x
    @parallax.camera_y = self.viewport.y
    @parallax.update
  end

  def draw
    @parallax.draw
    super
  end

end

class Doctor < Chingu::GameObject
  trait :bounding_box, :scale => 0.30
  traits :timer, :collision_detection , :timer, :velocity

  def setup
    self.input = {
      :holding_left => :move_to_left,
      :holding_right => :move_to_right,
      # :holding_up => :jump
    }

    @image = Image["doctor.jpg"]

    self.zorder = 300
    self.max_velocity = 10
    self.rotation_center = :bottom_center

    update
    cache_bounding_box
  end

  def move_to_left
    move(-5, 0)
  end

  def move_to_right
    move(5, 0)
  end

  def move(x, y)
    self.x += x
    self.y += y
  end

end

MainWindow.new.show
