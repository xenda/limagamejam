class BarLife < GameObject
  trait :timer
  
  attr_accessor :width, :height, :hero

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end


  def setup
  	@color = 0xffffffff
  	@width = 100
  	@height = 10
  	@zorder = 1000
  end

  def damage
    @color = 0xffff0000
    after(1000){
      @color = 0xffffffff
    }
  end

  def draw
  	#BORDER
  	#$window.draw_rect(Chingu::Rect.new(@x, @y, @width, @height), Gosu::Color.new(0xff000000), @zorder)

  	#FILL
    width = (@hero.health / 100.0) * $window.width.to_f - 20
	  $window.fill_rect(Chingu::Rect.new(@x, @y, width , @height), Gosu::Color.new(@color), @zorder)	
  end

  def check_life
    @width = 50
  end

end