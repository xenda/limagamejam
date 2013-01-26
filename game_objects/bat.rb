class Bat < GameObject
  trait :bounding_box, :debug => false #, :scale => 0.7
  trait :collision_detection

  def setup

    @state = :sleeping
    @direction = :right

    @animations = Animation.new(:file => "media/bat.png", :size => [50,46], :delay => 200);
    @animations.frame_names = {
    	:sleeping => 0, 
    	:fly_left => 1..4, 
    	:fly_right => 5..8 
    }

    @image = @animations[:sleeping]

    self.rotation_center = :top_center

    self.input = {
    	:b => :bat_fly
    }

    update
    cache_bounding_box
  end

  # def update



  # end

  # def draw

  # end

  def move(x, y)
    self.x = x
    self.y = y
  end

  def bat_fly
  	puts :batfly
  end
end