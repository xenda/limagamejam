class Doctor < Chingu::GameObject
  trait :bounding_box, :scale => 0.8, :debug => false
  traits :timer, :collision_detection , :timer, :velocity

  def setup
    @animations = {}
    # @animations[:normal] = Animation.new(:file => "media/char_001_sprite.png", :size => [72,72], :delay => 200);
    # @animations[:normal].frame_names = { :left => 0..3, :right => 4..5 }

    @animations[:run] = Animation.new(:file => "media/goomba_sprite.png", :size => [72,70], :delay => 120);
    @animations[:run].frame_names = { :left => 0..6, :right => 7..13 }

    @jumping = false
    @died = false
    @state = :run
    @direction = :left
    self.zorder = 300
    self.acceleration_y = 0.5
    self.max_velocity = 15
    self.rotation_center = :bottom_center

    update
    cache_bounding_box
  end

  def die
    @died = true
    self.velocity_y = -15
  end

  def update
    self.x -= 0.35
    @image = @animations[@state][@direction].next!
    self.each_collision(Floor, FloorMini) do |me, block|
      if self.velocity_y < 0
        me.y = block.bb.bottom + me.image.height * self.factor_y
        self.velocity_y = 0
      else
        unless @died
          @jumping = false
          me.y = block.bb.top
        end
      end
    end
  end
end