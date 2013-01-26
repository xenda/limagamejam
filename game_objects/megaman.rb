class Megaman < Chingu::GameObject
  trait :bounding_box, :scale => 0.8
  traits :timer, :collision_detection , :timer, :velocity

  attr_accessor :direction, :jumping, :health

  def setup
    self.input = {
      :holding_left => :move_to_left,
      :holding_right => :move_to_right,
      :holding_up => :jump
    }

    @state = :normal
    @direction = :right
    @health = 100

    @animations = {}
    @animations[:normal] = Animation.new(:file => "media/megaman-sprites-normal.png", :size => [72,72], :delay => 200);
    @animations[:normal].frame_names = { :left => 0..1, :right => 2..3 }

    @animations[:run] = Animation.new(:file => "media/megaman-sprites-run.png", :size => [72,72], :delay => 80);
    @animations[:run].frame_names = { :left => 0..2, :right => 3..5 }

    @animations[:jump] = Animation.new(:file => "media/megaman-sprites-jump.png", :size => [90,90]);
    @animations[:jump].frame_names = { :left => 0..1, :right => 2..3 }

    @image =  current_animation.first

    @jumping = false
    @died = false

    self.zorder = 300
    self.acceleration_y = 0.5
    self.max_velocity = 10
    self.rotation_center = :bottom_center

    update
    cache_bounding_box
  end

  def current_animation
    @animations[@state][@direction]
  end

  def move_to_left
    if @jumping
      @state = :jump
    else
      @state = :run
    end

    @direction = :left

    if self.x >= 30
      move(-5, 0)
    end
    #@image = Image["doctor-left.png"]
  end

  def move_to_right
    if @jumping
      @state = :jump
    else
      @state = :run
    end

    @direction = :right

    if self.x < 3200
      move(5, 0)
    end
    #@image = Image["doctor-right.png"]
  end

  def jump
    return if @jumping

    @state = :jump
    @jumping = true
    self.velocity_y = -10
  end

  def move(x, y)
    self.x += x
    self.y += y
  end

  def die
    @died = true
    self.velocity_y = -10
  end

  def winking
    orientation = (@direction==:right) ? 'first' : 'last';

    if @image == @animations[:normal][@direction].send( "#{orientation}".to_sym )
      return if Random.rand(10) != 0
    end

    @image = @animations[:normal][@direction].next
  end

  def idle
    !(self.holding_any? :left, :right, :jump) && !@jumping
  end

  def index_for_left
    (@direction == :right) ? 1 : 0
  end

  def index_for_right
    (@direction == :right) ? 0 : 1
  end

  def update

    if idle
      @state = :normal
      winking
    elsif @jumping
      if self.velocity_y < 0
        @image = @animations[:jump][@direction][index_for_left]
      else
        @image = @animations[:jump][@direction][index_for_right]
      end
    else
      @image = @animations[@state][@direction].next
    end

    self.each_collision(Floor) do |me, block|
      if self.velocity_y < 0
        me.y = block.bb.bottom + me.image.height * self.factor_y
        self.velocity_y = 0
      else
        unless @died
          @jumping = false
          me.y = block.bb.top
        end
      end
    end

    self.each_collision(PassableBox) do |me, stone_wall|
        @jumping = false
        # me.y = stone_wall.bb.top-1
    end


  end
end