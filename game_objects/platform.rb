class Platform < GameObject
  trait :bounding_box, :debug => true
  trait :collision_detection, :velocity

  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
    @image = Image["box_single.png"]
    @bounding_x = [@x - 100, @x + 100]
    self.width  = 31
    self.height = 31
    self.rotation_center = :bottom_left
    cache_bounding_box
  end

  def update
    if @x < @bounding_x.first
      @x += 1
      @direction = :right
    end

    if @x > @bounding_x.last
      @x -= 1
      @direction = :left
    end

  end
end