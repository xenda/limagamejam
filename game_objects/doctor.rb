class Doctor < Chingu::GameObject
  trait :bounding_box, :scale => 0.8
  traits :timer, :collision_detection , :timer, :velocity

  def setup
    self.input = {
      :holding_left => :move_to_left,
      :holding_right => :move_to_right,
      :holding_up => :jump
    }

    @image = Image["doctor-right.png"]

    @jumping = false
    @died = false

    self.zorder = 300
    self.acceleration_y = 0.5
    self.max_velocity = 10
    self.rotation_center = :bottom_center

    update
    cache_bounding_box
  end

  def move_to_left
    if self.x >= 30
      move(-5, 0)
    end
    @image = Image["doctor-left.png"]
  end

  def move_to_right
    if self.x < 3200
      move(5, 0)
    end
    @image = Image["doctor-right.png"]
  end

  def jump
    return if @jumping
    @jumping = true
    self.velocity_y = -10
  end

  def move(x, y)
    self.x += x
    self.y += y
  end

  def die
    @died = true
    self.velocity_y = -10
  end

  def is_jumping?
    @jumping
  end

  def update
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