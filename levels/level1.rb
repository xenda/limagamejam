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
      @x = $window.width / 2 - 130
      @y = 160
      @height = 30
      PulsatingText.new('Ganaste', {x: $window.width / 2 - 130, y: 160}).create_pulse
    end

  end

end