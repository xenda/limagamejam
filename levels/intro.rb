
class Intro < Chingu::GameState

  def setup
    @image = Image["start_screen.png"]
    self.input = { :escape => :exit , [:space, :s] => :start_game }
  end

  def start_game
    push_game_state(Chingu::GameStates::FadeTo.new(Level1.new, :speed => 10))
  end

  def update
    super
  end

  def draw
    super
    @image.draw(0,0,0)
  end

end