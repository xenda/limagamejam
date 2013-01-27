require 'ashton'

class Level < Chingu::GameState

  traits :viewport, :timer
  attr_accessor :game_object_map

  GAME_OBJECTS = [Saw, WoodFence, Pipe, Pipe2, BoxDouble, Platform, Doctor, SafeTree, GoalTree, EvilTree, Car, FloorMini, Bat]

  def initialize(options = {})
    super(options)

    self.viewport.game_area = [0, 0, 6035, 520]

    self.input = { :escape => :exit, :e => :edit, :holding_left_control => :enable_blur,
      :released_left_control => :disable_blur, :r => :restart }

    @bloom = Ashton::Shader.new fragment: :bloom
    @blur = Ashton::Shader.new fragment: :radial_blur

    @bloom.glare_size = 0.05
    @bloom.power = 0.05

    # GAME_OBJECTS.each(&:destroy_all)
    load_game_objects


    @game_object_map = GameObjectMap.new(:game_objects => Platform.all, :grid => @grid)
    @parallax_collection = []

    @parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @parallax << { :image => media_path("BG_003.png"), :damping => 4, :repeat_x => true, :repeat_y => true}

    # @second_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    # @second_parallax << { :image => media_path("BG_003.png"), :damping => 3, :repeat_x => true, :repeat_y => false}

    # @second_parallax.camera_y = self.viewport.game_area.last * -1

    @third_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @third_parallax << { :image => media_path("BG_002.png"), :damping => 2, :repeat_x => true, :repeat_y => false}

    @third_parallax.camera_y = self.viewport.game_area.last * -1

    @fourth_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @fourth_parallax << { :image => media_path("BG_001.png"), :damping => 1, :repeat_x => true, :repeat_y => false}

    @fourth_parallax.camera_y = self.viewport.game_area.last * -1

    @parallax_collection << @parallax
    # @parallax_collection << @second_parallax
    @parallax_collection << @third_parallax
    @parallax_collection << @fourth_parallax

    @saved_x, @saved_y = [100, 494]
    @hero = Megaman.create(:x => @saved_x, :y => @saved_y)

    @floor = Floor.create(:x => 0, :y => 520)
    @font = Gosu::Font.new $window, "media/uni05_54-webfont.ttf", 60
    @small_font = Gosu::Font.new $window, "media/uni05_54-webfont.ttf", 40
    @lifebar = BarLife.create(:x => 10, :y => 10)
    @lifebar.hero = @hero

    @music = Gosu::Song.new($window, "media/background2.wav")
    @music.play
    @timer = 100
    every(1000) { update_time }
    every(5000) { save_player_position }

    Bat.all.each do |bat|
     bat.heroReference = @hero
    end

   end


   def update_time
     @timer -= 1
   end

  def edit
    push_game_state(GameStates::Edit.new(:grid => [18,18], :classes => GAME_OBJECTS))
  end

   # def debug
   #   push_game_state(Chingu::GameStates::Debug.new({}))
   # end

    def restore_player_position
      @hero.x, @hero.y = @saved_x, @saved_y
    end
    
    def save_player_position
      @saved_x, @saved_y = @hero.x, @hero.y   if @hero.collidable && !@hero.jumping
    end

   def restart
     restore_player_position
   end

  def update
    super
    $gosu_blocks.clear if defined? $gosu_blocks # Workaround for Gosu bug (0.7.45)

    # REMOVE THINGS
    Bat.destroy_if { |bat| bat.outside_window? }
    Doctor.destroy_if { |doctor| doctor.outside_window? }

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
      if player.y.to_i <= question_box.bb.top.to_i + 10
        player.velocity_y = 0
        player.y = question_box.bb.top
      elsif player.y.to_i <= question_box.bb.bottom.to_i
        #monedas
        player.velocity_y = +2
      end
    end

    @hero.each_collision(Bat) do |me, bat|
      puts "bat damage"
      Gosu::Song.new($window, "media/damage.ogg").play
      me.health -= 0.2 unless me.health <= 15
    end

    @hero.each_collision(Doctor) do |me, doctor|
      Gosu::Song.new($window, "media/damage.ogg").play
      me.health -= 0.2 unless me.health <= 15
      me.hit_by(doctor)
      # if me.direction == :right
      #   me.x = me.previous_x - 150
      # else
      #   me.x = me.previous_x + 150
      # end
      ##me.direction = me.direction == :left ? :right : :left
      # puts "Hit"
      me.velocity_y = -7
      # @jumping = true

    end

    hero_resting = false
    @hero.each_collision(SafeTree) do |me, tree|
      Bat.all.each do |bat| 
        bat.hunting = false
      end
      hero_resting true
      @colliding = true
    end
    @hero.resting = hero_resting

    @hero.each_collision(GoalTree) do |me, tree|
      me.health += 0.05 unless me.health >= 100
      @colliding = true
    end

    @hero.each_collision(EvilTree) do |me, tree|
      me.health -= 0.15 unless me.health <= 30
      @colliding = true
    end

    if @hero.y > $window.height + 200
      restore_player_position
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
    # $window.post_process(@bloom, @blur) do
    # $window.post_process(@bloom) do
      @parallax_collection.each do |parallax|
        parallax.draw


      end
    #end
    
    super
    @font.draw_rel("MATUSITA", $window.width / 2 - 130, 160, 50, 0, 0.5)
    @small_font.draw_rel("Tiempo restante: #{@timer}", 10, 30, 50, 0, 0.5)
    @small_font.draw_rel("Vida: #{@hero.health.round}", $window.width - 160, 30 , 50, 0, 0.5)
    
  end

end