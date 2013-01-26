require 'ashton'

class Level1 < Chingu::GameState

  traits :viewport, :timer

  def initialize(options = {})
    super(options)

    self.viewport.game_area = [0, 0, 2835, 480]

    self.input = { :escape => :exit, :e => :edit }

    # @pixelate = Ashton::Shader.new fragment: :pixelate, uniforms: {
    #     pixel_size: @pixel_size = 1,
    # }

    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.00
    @bloom.power = 0.0

    load_game_objects

    @parallax_collection = []

    @parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @parallax << { :image => media_path("BG_004.png"), :damping => 4, :repeat_x => true, :repeat_y => true}

    @second_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @second_parallax << { :image => media_path("BG_003.png"), :damping => 3, :repeat_x => true, :repeat_y => false}

    @second_parallax.camera_y = self.viewport.game_area.last * -1

    @third_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @third_parallax << { :image => media_path("BG_002.png"), :damping => 2, :repeat_x => true, :repeat_y => false}

    @third_parallax.camera_y = self.viewport.game_area.last * -1

    @fourth_parallax = Parallax.new(:x => 0, :y => 0, :rotation_center => :top_left)
    @fourth_parallax << { :image => media_path("BG_001.png"), :damping => 1, :repeat_x => true, :repeat_y => false}

    @fourth_parallax.camera_y = self.viewport.game_area.last * -1

    @parallax_collection << @parallax
    @parallax_collection << @second_parallax
    @parallax_collection << @third_parallax
    @parallax_collection << @fourth_parallax

    @hero = Megaman.create(:x => 100, :y => 460)
    @floor = Floor.create(:x => 0, :y => 480)

    Bat.all.each do |bat|
     bat.heroReference = @hero
    end

    @font = Gosu::Font.new $window, "media/uni05_54-webfont.ttf", 60
    @music = Gosu::Song.new(self, "background1.m4a")
    @music.play
   end

  def edit
    push_game_state(GameStates::Edit.new(:grid => [32,32], :classes => [ GoalTree, Car, PassableBox, Floor, Bat]))
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

    @third_parallax.camera_x = self.viewport.x
    @third_parallax.camera_y = self.viewport.y - 310
    @third_parallax.update

    @fourth_parallax.camera_x = self.viewport.x
    @fourth_parallax.camera_y = self.viewport.y - 110
    @fourth_parallax.update

    @hero.each_collision(PassableBox) do |player, question_box|
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
    @font.draw_rel("MATUSITA", $window.width / 2 - 130, 260, 10, 0, 0.5)
    $window.post_process(@bloom) do
      @parallax_collection.each do |parallax|
        parallax.draw
      end
      super
    end
  end

end