require 'ashton'

class Level0 < Chingu::GameState

  traits :viewport, :timer

  def initialize(options = {})
    super(options)

    self.viewport.game_area = [0, 0, 2200, 480]

    self.input = { :escape => :exit, :e => :edit }

    @pixelate = Ashton::Shader.new fragment: :pixelate, uniforms: {
        pixel_size: @pixel_size = 2,
    }

    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.00
    @bloom.power = 0.0

    load_game_objects

    @parallax_collection = []

    @parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @parallax << { :image => media_path("background.jpg"), :damping => 3, :repeat_x => true, :repeat_y => true}

    @second_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :bottom_left)
    @second_parallax << { :image => media_path("grass.png"), :damping => 1, :repeat_x => true, :repeat_y => false}

    @second_parallax.camera_y = self.viewport.game_area.last * -1

    @parallax_collection << @parallax
    @parallax_collection << @second_parallax

    @hero = Megaman.create(:x => 100, :y => 460)
    @floor = Floor.create(:x => 0, :y => 480)

    @font = Gosu::Font.new $window, "media/uni05_54-webfont.ttf", 60

   end

  def edit
    push_game_state(GameStates::Edit.new(:grid => [32,32], :classes => [Megaman, Car, QuestionBox, Floor]))
  end

  def update
    super
    $gosu_blocks.clear if defined? $gosu_blocks # Workaround for Gosu bug (0.7.45)

    self.viewport.center_around(@hero)

    @parallax.camera_x = self.viewport.x
    @parallax.camera_y = self.viewport.y
    @parallax.update

    @second_parallax.camera_x = self.viewport.x
    @second_parallax.camera_y = self.viewport.y - 610
    @second_parallax.update

  end

  def draw
    @font.draw_rel("MATUSITA", $window.width / 2 - 130, 260, 500, 0, 0.5, 1, 1, 0xccfc8e2e)
      $window.post_process(@pixelate) do
        @parallax_collection.each do |parallax|
          parallax.draw
        end
        super
      end
  end

end