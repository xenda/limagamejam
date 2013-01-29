class Bat < GameObject
  trait :bounding_box, :debug => true, :scale => 0.4
  trait :collision_detection, :velocity

  attr_accessor :hunting, :heroReference, :direction

  def setup
    @hunt_range = 400

    @speed_rondando = 1.0
    @speed_back     = 1.5
    @speed          = 2.0

  	@hunting = false
    @state = :fly_right
    @direction = :right
    
    @returning = false
    @start_y = @y
    @start_x = @x

    @bounding_x = [@x - 35+rand(10), @x + 35+rand(10)]
    @bounding_y = [@y - 25+rand(5), @y + 25 + rand(5)]
    @towards_x = rand(1) == 0 ? 1 : -1

    @zorder = 500

    @animations = Animation.new(:file => "media/vamp_fly_sprite.png", :size => [72,72], :delay => 120);
    @animations.frame_names = {
      :fly_left => 0..3,
      :fly_right => 4..7
    }

    @image = @animations[@state]

    self.rotation_center = :bottom_center

    self.input = {
    	:b => :bat_fly
    }

    update
    cache_bounding_box
  end


  def update

    if @heroReference
      
      if Gosu::distance(@heroReference.x, @heroReference.y, self.x, self.y) < @hunt_range
        @hunting = true if !@heroReference.resting
      else
        if @hunting
          @hunting = false
          @returning = true
        end
      end

    end


    if @hunting && @heroReference

      if @heroReference.resting 
        @returning = true
        @hunting = false
        yDistance = @start_y - self.y;
        xDistance = @start_x - self.x;
      else
        yDistance = @heroReference.y - @heroReference.height - self.y;
        xDistance = @heroReference.x - self.x;
      end

      radian = Math.atan2(yDistance, xDistance)

      if @heroReference.resting 
        self.x += Math.cos(radian) * @speed_back
        self.y += Math.sin(radian) * @speed_back
      else
        self.x += Math.cos(radian) * @speed;
        self.y += Math.sin(radian) * @speed;
      end

      #self.angle = radian * 180 / Math::PI;

      if @x < @heroReference.x
        @state = :fly_right
      else
        @state = :fly_left
      end

    else

      if @returning

      else
        # PATRULLANDO

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

        move_x(@speed_rondando, @towards_x)
      end

    end

    

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