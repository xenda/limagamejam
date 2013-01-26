class BarLife < GameObject
  
  attr_accessor :width, :height, :hero

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
  	@color = 0xffffff
  	@width = 100
  	@height = 10
  	@zorder = 1000
  end

  def draw
  	#BORDER
  	#$window.draw_rect(Chingu::Rect.new(@x, @y, @width, @height), Gosu::Color.new(0xff000000), @zorder)
  	
  	#FILL
    width = (@hero.health / 100.0) * $window.width.to_f - 20
	  $window.fill_rect(Chingu::Rect.new(@x, @y, width , @height), Gosu::Color.new(0xffffffff), @zorder)	
  end

  def check_life
    @width = 50
  end

end