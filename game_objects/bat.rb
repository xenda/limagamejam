class Bat < GameObject
  trait :bounding_box, :debug => false #, :scale => 0.7
  trait :collision_detection, :velocity

  attr_accessor :hunting, :heroReference, :direction

  def setup

    @speed = 2
  	@hunting = false
    @state = :fly_right
    @direction = :right
    @start_y = @y
    @bounding_x = [@x - 35+rand(10), @x + 35+rand(10)]
    @bounding_y = [@y - 25+rand(5), @y + 25 + rand(5)]
    @towards_x = rand(1) == 0 ? 1 : -1
    @towards_y = rand(1) == 0 ? 1 : -1

    @animations = Animation.new(:file => "media/vamp_fly_sprite.png", :size => [72,72], :delay => 120);
    @animations.frame_names = {
      :fly_left => 0..3,
      :fly_right => 4..7
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

    if @heroReference
          
      if Gosu::distance(@heroReference.x, @heroReference.y, self.x, self.y) < 100
        @hunting = true
      else
        @hunting = false
      end

    end


    if @hunting && @heroReference

      yDistance = @heroReference.y - self.y;
      xDistance = @heroReference.x - self.x;

      radian = Math.atan2(yDistance, xDistance)

      self.x += Math.cos(radian) * @speed;
      self.y += Math.sin(radian) * @speed;

      #self.angle = radian * 180 / Math::PI;

      if @x < @heroReference.x
        @state = :fly_right
      else
        @state = :fly_left
      end
      
    else

      @y -= 1 if @y < @start_y

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
  end
end