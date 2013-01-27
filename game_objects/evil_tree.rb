class EvilTree < GameObject
  trait :bounding_box, :scale => 0.5#, :debug => true
  trait :collision_detection

  # def self.solid
  #   all.select { |block| block.alpha == 255 }
  # end

  # def self.inside_viewport
  #   all.select { |block| block.game_state.viewport.inside?(block) }
  # end


  def setup
    @image = Image["evil_tree.png"]

    self.width = 350
    self.height = 798

    self.rotation_center = :bottom_center
    cache_bounding_box
    # after(6000) { self.destroy }
  end



end
