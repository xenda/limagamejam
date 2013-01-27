class Megaman < Chingu::GameObject
  trait :bounding_box, :scale => 0.8, debug: true
  traits :timer, :collision_detection,  :velocity

  attr_accessor :direction, :jumping, :health

  def setup
    self.input = {
      :holding_left  => :move_to_left,
      :holding_right => :move_to_right,
      [:holding_up, :holding_space, :z] => :jump,
      [:holding_left_control,  :x] => :add_multiplier,
      [:released_left_control, :x] => :remove_multiplier
    }

    @state = :normal
    @direction = :right

    @health = 100
    @multiplier = 1
    @damage_per_turn = 1

    @animations = {}
    @animations[:normal] = Animation.new(:file => "media/char_001_sprite.png", :size => [72,72], :delay => 200);
    @animations[:normal].frame_names = { :left => 0..3, :right => 4..5 }

    @animations[:run] = Animation.new(:file => "media/char_001_sprite.png", :size => [72,70], :delay => 100);
    @animations[:run].frame_names = { :left => 0..3, :right => 4..7 }

    @animations[:jump] = Animation.new(:file => "media/char_002_sprite.png", :size => [72,72], :delay => 70);
    @animations[:jump].frame_names = { :left => 0..2, :right => 3..5 }

    @image = current_animation.first

    @jumping = false
    @died = false

    self.zorder = 300
    self.acceleration_y  = 0.5
    self.max_velocity    = 15
    self.rotation_center = :bottom_center

    update
    cache_bounding_box
    every(1000){ take_damage unless idle? }
  end

  def current_animation
    @animations[@state][@direction]
  end



  def add_multiplier
    @multiplier = 2
    @health -= 0.10
  end

  def remove_multiplier
    @multiplier = 1
  end

  def move_to_left
    if @jumping
      @state = :jump
    else
      @state = :run
    end

    @direction = :left

    if self.x >= 30
      move(-5*@multiplier, 0)
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

    if self.x < 6035
      move(5*@multiplier, 0)
    end
    #@image = Image["doctor-right.png"]
  end

  def jump
    return if @jumping

    Gosu::Song.new($window, "media/buzzer.ogg").play
    
    @state = :jump
    @jumping = true
    self.velocity_y = -10*(@multiplier > 1 ? 1.5 : @multiplier)
    # self.velocity_y = -10
  end

  def move(x, y)
    self.x += x
    self.y += y
  end

  def hit_by(object)
    #
    # during() and then() is provided by the timer-trait
    # flash red for 300 millisec when hit, then go back to normal
    #
    if [Doctor, Bat].include? object
      puts "Wiii"
      during(100) { self.color = @red; self.mode = :additive }.then { self.color = @white; self.mode = :default }
    end
  end

  def die
    @died = true
    self.velocity_y = -2
    # self.acceleration_y = 1
    between(1000,12000) { self.velocity_y -= 1; self.scale += 5; self.alpha -= 25; }
  end

  def winking
    orientation = (@direction==:right) ? 'first' : 'last';

    if @image == @animations[:normal][@direction].send( "#{orientation}".to_sym )
      return if Random.rand(10) != 0
    end

    @image = @animations[:normal][@direction].next
  end

  def idle?
    !(self.holding_any? :left, :right, :jump) && !@jumping
  end

  def index_for_left
    (@direction == :right) ? 1 : 0
  end

  def index_for_right
    (@direction == :right) ? 0 : 1
  end

  def take_damage
    @health -= @damage_per_turn
  end

  def update

    if idle?
      @state = :normal
      winking
    elsif @jumping
      if self.velocity_y < 0
        @image = @animations[:jump][@direction][0]
      else
        @image = @animations[:jump][@direction][1]
      end
    else
      @image = @animations[@state][@direction].next!
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

    self.each_collision(Platform) do |me, stone_wall|
        @jumping = false
        @x += ( stone_wall.direction == :left ) ? -1 : 1
        # me.y = stone_wall.bb.top-1
    end

  end
end