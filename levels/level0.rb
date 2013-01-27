require_relative 'level'

class Level0 < Level

  traits :viewport, :timer

  def update
    super
    @hero.each_collision(GoalTree) do |me, tree|
      me.jumping = true
      #switch_game_state(Level1)
      push_game_state(Chingu::GameStates::FadeTo.new(Level1.new, :speed => 10))
    end
  end

end