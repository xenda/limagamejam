require_relative 'level'

class Level1 < Level

  traits :viewport, :timer

  def initialize(options = {})
    super(options)

    Bat.all.each do |bat|
     bat.heroReference = @hero
    end

   end


  def update
    super

    @hero.each_collision(GoalTree) do |me, tree|
      # me.jumping = true
      # switch_game_state(Level1)
    end

  end

end