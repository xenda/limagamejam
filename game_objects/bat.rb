class Bat < GameObject
  trait :bounding_box, :debug => false #, :scale => 0.7
  trait :collision_detection

  attr_accessor :hunting, :heroReference

  def setup

    @speed = 2
  	@hunting = false
    @state = :sleeping
    @direction = :right

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
  	if @heroReference      

      yDistance = @heroReference.y - self.y;
      xDistance = @heroReference.x - self.x;

      radian = Math.atan2(yDistance, xDistance)

      self.x += Math.cos(radian) * @speed;
      self.y += Math.sin(radian) * @speed;

      #self.angle = radian * 180 / Math::PI;

      if self.x < @heroReference.x
        @state = :fly_right
      else
        @state = :fly_left
      end
    end

    case @state
  		when :sleeping
        @image = @animations[@state]
  		when :fly_right, :fly_left
  			@image = @animations[@state].next
    end
  end

  def move(x, y)
    self.x = x
    self.y = y
  end

  
  def bat_fly
  	@state = :fly_right
  end
end