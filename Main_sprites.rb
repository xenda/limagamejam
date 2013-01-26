require 'chingu'
require 'ashton'
include Gosu
include Chingu

def media_path(file); File.expand_path "media/#{file}", File.dirname(__FILE__) end

class MainWindow < Chingu::Window
  def initialize
    super 640, 480
    self.caption = "Max Alvarez"

    self.input = { :escape => :exit }

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

    self.viewport.game_area = [0, 0, 3200, 480]

    @parallax_collection = []

    @parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @parallax << { :image => media_path("background.jpg"), :damping => 3, :repeat_x => true, :repeat_y => true}

    @second_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :bottom_left)
    @second_parallax << { :image => media_path("grass.png"), :damping => 1, :repeat_x => true, :repeat_y => false}

    @second_parallax.camera_y = self.viewport.game_area.last * -1

    @parallax_collection << @parallax
    @parallax_collection << @second_parallax

    @doctor = Doctor.create(:x => 100, :y => 460)
    @floor = Floor.create(:x => 0, :y => 480)
  end

  def update
    super

    self.viewport.center_around(@doctor)

    @parallax.camera_x = self.viewport.x
    @parallax.camera_y = self.viewport.y
    @parallax.update

    @second_parallax.camera_x = self.viewport.x
    @second_parallax.camera_y = self.viewport.y - 610
    @second_parallax.update
  end

  def draw
    @parallax_collection.each do |parallax|
      parallax.draw
    end

    super
  end

end

class Doctor < Chingu::GameObject
  trait :bounding_box, :scale => 0.8
  traits :timer, :collision_detection , :timer, :velocity

  def setup
    self.input = {
      :holding_left => :move_to_left,
      :holding_right => :move_to_right,
      :holding_up => :jump
    }

    @image = Image["doctor-right.png"]

    @jumping = false

    self.zorder = 300
    self.acceleration_y = 0.5
    self.max_velocity = 10
    self.rotation_center = :bottom_center

    update
    cache_bounding_box
  end

  def move_to_left
    if self.x >= 30
      move(-5, 0)
    end
    @image = Image["doctor-left.png"]
  end

  def move_to_right
    if self.x < 3200
      move(5, 0)
    end
    @image = Image["doctor-right.png"]
  end

  def jump
    return if @jumping
    @jumping = true
    self.velocity_y = -10
  end

  def move(x, y)
    self.x += x
    self.y += y
  end

  def update
    self.each_collision(Floor) do |me, block|
      if self.velocity_y < 0
        me.y = block.bb.bottom + me.image.height * self.factor_y
        self.velocity_y = 0
      else
        @jumping = false
        me.y = block.bb.top - 1
      end
    end
  end

end

class Floor < GameObject
  trait :bounding_box, :debug => false
  trait :collision_detection
  
  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
    @image = Image["burried.png"]
    @color = Color.new(0xff808080)
    self.width = 3200
    self.height = 40
    self.rotation_center = :bottom_left
    cache_bounding_box
  end

end

MainWindow.new.show
