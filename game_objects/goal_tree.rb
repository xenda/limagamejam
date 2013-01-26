class GoalTree < GameObject
  trait :bounding_box, :debug => true, :scale => 1.5
  trait :collision_detection

  def setup
    @image = Image["old_tree.png"]

    self.width = 726
    self.height = 798

    self.rotation_center = :bottom
    cache_bounding_box
    # after(6000) { self.destroy }
  end



end