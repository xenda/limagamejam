require 'ashton'

class Level1 < Chingu::GameState

  traits :viewport, :timer

  def initialize(options = {})
    super(options)

    self.viewport.game_area = [0, 0, 3200, 480]
    @pixelate = Ashton::Shader.new fragment: :pixelate, uniforms: {
        pixel_size: @pixel_size = 1,
    }


    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.010
    @bloom.power = 0.2



    @parallax_collection = []

    @parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @parallax << { :image => media_path("background.jpg"), :damping => 3, :repeat_x => true, :repeat_y => true}

    @second_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :bottom_left)
    @second_parallax << { :image => media_path("grass.png"), :damping => 1, :repeat_x => true, :repeat_y => false}

    @second_parallax.camera_y = self.viewport.game_area.last * -1

    @parallax_collection << @parallax
    @parallax_collection << @second_parallax

    @bat = Bat.create(:x => 0, :y => 0)
    @hero = Megaman.create(:x => 100, :y => 460)
    @floor = Floor.create(:x => 0, :y => 480)

    @boxes = []

    5.times do |i|
      @boxes << QuestionBox.create(:x => (i + 1) * 250, :y => 340)
    end

    @car = Car.create(:x => 600, :y => 440)

    @font = Gosu::Font.new $window, "media/uni05_54-webfont.ttf", 60
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

    @hero.each_collision(Car) do |player, car|
      distance = (player.x - car.x).abs

      if (player.y == car.y) && (distance < car.width / 2)
        #puts [distance, car.width / 2]
        player.die
      end
    end

    @hero.each_collision(QuestionBox) do |player, question_box|
      if player.y.to_i <= question_box.bb.top.to_i + 5
        player.velocity_y = 0
        player.y = question_box.bb.top
      elsif player.y.to_i <= question_box.bb.bottom.to_i
        #monedas
        player.velocity_y = +2
      end
    end
  end

  def draw
    @font.draw_rel("MATUSITA", $window.width / 2 - 130, 60, 500, 0, 0.5, 1, 1, 0xccfc8e2e)
      $window.post_process(@pixelate, @bloom) do
        @parallax_collection.each do |parallax|
          parallax.draw
        end
        super
      end
  end

end