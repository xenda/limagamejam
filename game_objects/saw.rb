class Saw < GameObject
  # trait :bounding_box, :debug => false
  # trait :collision_detection

  # def self.solid
  #   all.select { |block| block.alpha == 255 }
  # end

  # def self.inside_viewport
  #   all.select { |block| block.game_state.viewport.inside?(block) }
  # end

  def setup
    @image = Image["saw.png"]
    @bounding_box_y = [@y - 50, @y+50]
    self.width = 325
    self.height = 324
    self.rotation_center = :center_center
    # cache_bounding_box
  end

  def update
    @angle += 1

    @y_direction = :top if @y < @bounding_box_y.first
    @y_direction = :bottom  if @y > @bounding_box_y.last

    case @y_direction
      when :bottom
        @x += 1
      when :top
        @x -= 1
    end

  end
end