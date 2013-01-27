class Saw < GameObject
  trait :bounding_box, :debug => true
  trait :collision_detection

  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
    @image = Image["saw.png"]
    @bounding_box_y = [@y - 15, @y + 15]
    @y_direction = :down
    self.width = 325
    self.height = 324
    self.rotation_center = :center_center
    # cache_bounding_box
  end

  def update
    @angle += 1

    @y_direction = :down if @y < @bounding_box_y.first
    @y_direction = :up  if @y > @bounding_box_y.last

    case @y_direction
      when :down
        @y += 0.5
      when :up
        @y -= 0.5
    end

  end
end