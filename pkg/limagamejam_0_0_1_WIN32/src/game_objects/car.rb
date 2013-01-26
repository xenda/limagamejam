class Car < GameObject
  trait :bounding_box, :debug => false, :scale => 0.7
  trait :collision_detection

  def setup
    @image = Image["Trash_can_lev.png"]

    self.width = 72
    self.height = 72

    self.rotation_center = :center
    cache_bounding_box
    # after(6000) { self.destroy }
  end

  # def update
  #   @angle += 5
  # end




end