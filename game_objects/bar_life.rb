class BarLife < GameObject
  
  attr_accessor :width, :height

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
  	$window.fill_rect(Chingu::Rect.new(@x, @y, @width, @height), Gosu::Color.new(0xff000000), @zorder)	
  end

  def check_life
    @width = 50
  end

end