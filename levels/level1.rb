require 'ashton'

class Level1 < Chingu::GameState

  traits :viewport, :timer

  def initialize(options = {})
    super(options)

    self.viewport.game_area = [0, 0, 3200, 480]
    @pixelate = Ashton::Shader.new fragment: :pixelate, uniforms: {
        pixel_size: @pixel_size = 2,
    }


    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.001
    @bloom.power = 0.2



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

    self.viewport.center_around(@doctor)

    @parallax.camera_x = self.viewport.x
    @parallax.camera_y = self.viewport.y
    @parallax.update

    @second_parallax.camera_x = self.viewport.x
    @second_parallax.camera_y = self.viewport.y - 610
    @second_parallax.update

    @doctor.each_collision(Car) do |player, car|
      distance = (player.x - car.x).abs

      if (player.y == car.y) && (distance < car.width / 2)
        #puts [distance, car.width / 2]
        player.die
      end
    end

    @doctor.each_collision(QuestionBox) do |player, question_box|
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
      post_process(@bloom, @pixelate) do
        @parallax_collection.each do |parallax|
          parallax.draw
        end
        super
      end
  end

  def post_process(*shaders)

      raise ArgumentError, "Block required" unless block_given?
      raise TypeError, "Can only process with Shaders" unless shaders.all? {|s| s.is_a? Ashton::Shader }

      # In case no shaders are passed, just run the contents of the block.
      unless shaders.size > 0
        yield
        return
      end

      buffer1 = $window.primary_buffer
      buffer1.clear

      # Allow user to draw into a buffer, rather than the window.
      buffer1.render do
        yield
      end

      if shaders.size > 1
        buffer2 = $window.secondary_buffer # Don't need to clear, since we will :replace.

        # Draw into alternating buffers, applying each shader in turn.
        shaders[0...-1].each do |shader|
          buffer1, buffer2 = buffer2, buffer1
          buffer1.render do
            buffer2.draw 0, 0, nil, shader: shader, mode: :replace
          end
        end
      end

      # Draw the buffer directly onto the window, utilising the (last) shader.
      buffer1.draw 0, 0, nil, shader: shaders.last
    end


end