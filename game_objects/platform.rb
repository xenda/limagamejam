class Platform < GameObject
  trait :bounding_box, :debug => true, scale: 0.8
  trait :collision_detection, :velocity

  attr_accessor :previous_x, :direction

  def self.solid
    all.select { |block| block.alpha == 255 }
  end

  def self.inside_viewport
    all.select { |block| block.game_state.viewport.inside?(block) }
  end

  def setup
    
    @direction = :left #[:left,:right][ Random.rand(2).to_i ]

    @image = Image["platform.png"]
    @bounding_x = [@x - 100, @x + 100]
    self.width  = 114
    self.height = 38
    self.rotation_center = :bottom_center

    cache_bounding_box
  end

  def update
    @direction = :right if @x < @bounding_x.first
    @direction = :left  if @x > @bounding_x.last

    case @direction
      when :right
        @x += 1
      when :left
        @x -= 1
    end

  end
end