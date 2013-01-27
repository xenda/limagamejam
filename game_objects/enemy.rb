class Enemy < Chingu::GameObject
  trait :bounding_box, :scale => 0.8
  traits :timer, :collision_detection , :timer, :velocity

  attr_accessor :direction

  def setup
		@image = Image["botiquin.png"]

		self.rotation_center = :bottom_center

  end

end