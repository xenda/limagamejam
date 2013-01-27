class Pipe2 < GameObject
  # trait :bounding_box, :debug => false
  # trait :collision_detection

  # def self.solid
  #   all.select { |block| block.alpha == 255 }
  # end

  # def self.inside_viewport
  #   all.select { |block| block.game_state.viewport.inside?(block) }
  # end

  def setup
    @image = Image["pipes2.png"]
    self.width = 79
    self.height = 72
    self.rotation_center = :bottom_left
    # cache_bounding_box
  end
end