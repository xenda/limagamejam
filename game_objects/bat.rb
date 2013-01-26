class Bat < GameObject
  trait :bounding_box, :debug => false #, :scale => 0.7
  trait :collision_detection, :velocity

  attr_accessor :hunting, :heroReference, :direction

  def setup

  	@hunting = false
    @state = :fly_right
    @direction = :right
    @bounding_x = [@x - 35+rand(10), @x + 35+rand(10)]
    @bounding_y = [@y - 25+rand(5), @y + 25 + rand(5)]
    @towards_x = rand(1) == 0 ? 1 : -1
    @towards_y = rand(1) == 0 ? 1 : -1

    @animations = Animation.new(:file => "media/bat.png", :size => [50,46], :delay => 120);
    @animations.frame_names = {
    	:sleeping => 0, 
    	:fly_left => 1..4, 
    	:fly_right => 5..8 
    }

    @image = @animations[@state]

    self.rotation_center = :top_center

    self.input = {
    	:b => :bat_fly
    }

    update
    cache_bounding_box
  end


  def update
	 # if @heroReference
  #     self.x += @heroReference.x * 0.007
  #     self.y += @heroReference.y * 0.007
  #   end

    if @x < @bounding_x.first
      @direction = :right
      @towards_x = 1
      @state = :fly_right
    end

    if @x > @bounding_x.last
      @direction = :left
      @towards_x = -1
      @state = :fly_left
    end

    @towards_y = 1 if @y < @bounding_y.first
    @towards_y = -1 if @y > @bounding_y.first

    move_x(1, @towards_x)
    # move_y(0.5, @towards_y)

    case @state
  		when :sleeping
        @image = @animations[@state]
  		when :fly_right, :fly_left
  			@image = @animations[@state].next
    end
  end

  def move_x(step, direction)
    move(step*direction, 0)
  end

  def move_y(step, direction)
    move(0, step*direction)
  end


  def move(x, y)
    self.x += x
    self.y += y
  end

  
  def bat_fly
  	@state = :fly_right

  	#puts @hunting
    puts @heroReference
  end
end