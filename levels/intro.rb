
class Intro < Chingu::GameState

  def setup
    @image = Image["start_screen.png"]
    self.input = { :escape => :exit , [:space, :s] => :start_game }
  end

  def start_game
    # @image.x = 0
    # @image.y = 0
    # @image.width  = $window.width
    # @image.height = $window.height
    # during(4000){ @hero.x += 1 }
    puts "Hi"
    push_game_state(Chingu::GameStates::FadeTo.new(Level0.new, :speed => 10))
  end

  def update
    super
  end

  def draw
    super
    @image.draw(0,0,0)
  end

end