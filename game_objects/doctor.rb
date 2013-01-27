class Doctor < Chingu::GameObject
  trait :bounding_box, :scale => 0.8, debug: true
  traits :timer, :collision_detection , :timer, :velocity

  def setup
    @image = Image["doctor-right.png"]

    @jumping = false
    @died = false

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
    self.x -= 0.9

    self.each_collision(Floor) do |me, block|
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