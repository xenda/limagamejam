class Car < GameObject
  trait :bounding_box, :debug => false, :scale => 0.7
  trait :collision_detection

  def setup
    @image = Image["car.png"]

    self.width = 179
    self.height = 53

    self.rotation_center = :bottom_left
    cache_bounding_box
  end
end