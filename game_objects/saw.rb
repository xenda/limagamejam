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
    self.width = 325
    self.height = 324
    self.rotation_center = :center_center
    # cache_bounding_box
  end

  def update
    @angle += 1
  end
end