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

    @boxes = []

    5.times do |i|
      @boxes << QuestionBox.create(:x => (i + 1) * 250, :y => 380)
    end

    @car = Car.create(:x => 600, :y => 440)

    @font = Gosu::Font.new $window, Gosu::default_font_name, 40
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

    @doctor.each_collision(Car) do |player, car|
      distance = (player.x - car.x).abs

      if (player.y == car.y) && (distance < car.width / 2)
        puts [distance, car.width / 2]
        player.die
      end
    end

    @doctor.each_collision(QuestionBox) do |player, question_box|
      if player.is_jumping?
        player.velocity_y = 0
        player.y = question_box.bb.top
      end
    end
  end

  def draw
    @font.draw_rel("WELCOME", $window.width / 2 - 70, $window.height / 2, 500, 0, 0.5, 1, 1, 0xaaffffff)

    @parallax_collection.each do |parallax|
      parallax.draw
    end

    super
  end
end