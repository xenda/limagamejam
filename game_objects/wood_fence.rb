class WoodFence < GameObject
  # trait :bounding_box, :debug => false
  # trait :collision_detection

  # def self.solid
  #   all.select { |block| block.alpha == 255 }
  # end

  # def self.inside_viewport
  #   all.select { |block| block.game_state.viewport.inside?(block) }
  # end

  def setup
    @image = Image["wood_fence.png"]
    self.width = 229
    self.height = 72
    self.rotation_center = :bottom_left
    # cache_bounding_box
  end
end