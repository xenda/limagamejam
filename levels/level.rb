require 'ashton'

class Level < Chingu::GameState

  traits :viewport, :timer

  def initialize(options = {})
    super(options)

    self.viewport.game_area = [0, 0, 2835, 520]

    self.input = { :escape => :exit, :e => :edit, :holding_left_control => :enable_blur,
      :released_left_control => :disable_blur }

    @bloom = Ashton::Shader.new fragment: :bloom
    @blur = Ashton::Shader.new fragment: :radial_blur

    @bloom.glare_size = 0.05
    @bloom.power = 0.05

    load_game_objects

    @parallax_collection = []

    @parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_center)
    @parallax << { :image => media_path("BG_003.png"), :damping => 4, :repeat_x => true, :repeat_y => true}

    # @second_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    # @second_parallax << { :image => media_path("BG_003.png"), :damping => 3, :repeat_x => true, :repeat_y => false}

    # @second_parallax.camera_y = self.viewport.game_area.last * -1

    @third_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_center)
    @third_parallax << { :image => media_path("BG_002.png"), :damping => 2, :repeat_x => true, :repeat_y => false}

    @third_parallax.camera_y = self.viewport.game_area.last * -1

    @fourth_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_center)
    @fourth_parallax << { :image => media_path("BG_001.png"), :damping => 1, :repeat_x => true, :repeat_y => false}

    @fourth_parallax.camera_y = self.viewport.game_area.last * -1

    @parallax_collection << @parallax
    # @parallax_collection << @second_parallax
    @parallax_collection << @third_parallax
    @parallax_collection << @fourth_parallax

    @hero = Megaman.create(:x => 100, :y => 490)

    @floor = Floor.create(:x => 0, :y => 520)
    @font = Gosu::Font.new $window, "media/uni05_54-webfont.ttf", 60
    @small_font = Gosu::Font.new $window, "media/uni05_54-webfont.ttf", 40
    @lifebar = BarLife.create(:x => 10, :y => 10)
    @lifebar.hero = @hero

    @music = Gosu::Song.new($window, "media/background2.mp3")
    @music.play
    @timer = 100
    every(1000) { update_time }
   end


   def update_time
     @timer -= 1
   end

  def edit
    push_game_state(GameStates::Edit.new(:grid => [18,18], :classes => [Saw, WoodFence, Pipe, Pipe2, BoxDouble, Platform, Doctor, GoalTree, EvilTree, Car, PassableBox, Floor, Bat]))
  end

   # def debug
   #   push_game_state(Chingu::GameStates::Debug.new({}))
   # end


  def update
    super
    $gosu_blocks.clear if defined? $gosu_blocks # Workaround for Gosu bug (0.7.45)

    self.viewport.center_around(@hero)

    @parallax.camera_x = self.viewport.x
    @parallax.camera_y = self.viewport.y
    @parallax.update
    @colliding = false
    # @second_parallax.camera_x = self.viewport.x
    # @second_parallax.camera_y = self.viewport.y - 610
    # @second_parallax.update

    @third_parallax.camera_x = self.viewport.x
    @third_parallax.camera_y = self.viewport.y - 310
    @third_parallax.update

    @fourth_parallax.camera_x = self.viewport.x
    @fourth_parallax.camera_y = self.viewport.y - 110
    @fourth_parallax.update

    # REGULAR COLLISIONS
    @hero.each_collision(Platform) do |player, question_box|
      if player.y.to_i <= question_box.bb.top.to_i + 5
        player.velocity_y = 0
        player.y = question_box.bb.top
      elsif player.y.to_i <= question_box.bb.bottom.to_i
        #monedas
        player.velocity_y = +2
      end
    end

    @hero.each_collision(Bat, Doctor) do |me, tree|
      me.health -= 0.2 unless me.health <= 15
      # if me.direction == :right
      #   me.x = me.previous_x - 150
      # else
      #   me.x = me.previous_x + 150
      # end
      me.direction = me.direction == :left ? :right : :left
      puts "Hit"
      me.velocity_y = -9
      @jumping = true

    end

    @hero.each_collision(GoalTree) do |me, tree|
      me.health += 0.05 unless me.health >= 100
      @colliding = true
    end

    @hero.each_collision(EvilTree) do |me, tree|
      me.health -= 0.15 unless me.health <= 30
      @colliding = true
    end

    if @colliding
      enable_bloom
    else
      disable_bloom
    end

    if ( @hero.health || @timer ) <= 0
      @hero.die
    end

  end

  def enable_blur
    @blur.spacing = 1.0
    @blur.strength = 1.0
  end

  def disable_blur
    @blur.spacing = 0.0
    @blur.strength = 0.0
  end

  def enable_bloom
    @bloom.glare_size = 0.05
    @bloom.power = 0.2
  end

  def disable_bloom
    @bloom.glare_size = 0.05
    @bloom.power = 0.05
  end

  def draw

    @lifebar.x = self.viewport.x + 10;
    @lifebar.y = self.viewport.y + 10;
    $window.post_process(@bloom, @blur) do
      @parallax_collection.each do |parallax|
        parallax.draw
      end
      super
    end


    @font.draw_rel("MATUSITA", $window.width / 2 - 130, 160, 10, 0, 0.5)
    @small_font.draw_rel("Tiempo restante: #{@timer}", 10, 30, 10, 0, 0.5)
    @small_font.draw_rel("Vida: #{@hero.health.round}", $window.width - 160, 30 , 10, 0, 0.5)
  end

end