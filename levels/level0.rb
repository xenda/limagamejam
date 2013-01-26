require_relative 'level'

class Level0 < Level

  traits :viewport, :timer

  def update
    super
    @hero.each_collision(GoalTree) do |me, tree|
      me.jumping = true
      # clear_game_states; push_game_state(Level1)
    end
  end

end