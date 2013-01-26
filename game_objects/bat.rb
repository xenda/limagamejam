class Bat < GameObject
  trait :bounding_box, :debug => false #, :scale => 0.7
  trait :collision_detection

  attr_accessor :hunting

  def setup

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

  	puts @hunting
  end
end