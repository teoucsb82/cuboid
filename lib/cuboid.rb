##
# This class represents an arbitrary rectangular cuboid by origin and dimensions.

class Cuboid
  attr_reader :origin
  
  #BEGIN public methods that should be your starting point
  def initialize(origin = {}, length, width, height)
    @origin = origin
    @length = length
    @width = width
    @height = height
  end

  def move_to!(x, y, z)
    return raise 'Coordinates must be integers' unless [x, y, z].all? { |coord| coord.is_a?(Integer) }
    return raise 'Coordinates must be positive' if [x, y, z].any? { |coord| coord < 0 }
    @origin[:x] = x
    @origin[:y] = y
    @origin[:z] = z
    true
  end
  
  def vertices
    [
      rear_bottom_left_coordinates,
      rear_bottom_right_coordinates,
      front_bottom_left_coordinates,
      front_bottom_right_coordinates,
      rear_top_left_coordinates,
      rear_top_right_coordinates,
      front_top_left_coordinates,
      front_top_right_coordinates
    ]
  end
  
  #returns true if the two cuboids intersect each other.  False otherwise.
  def intersects?(other)
  end

  #END public methods that should be your starting point  

  private

  def front_bottom_left_coordinates
    { x: @origin[:x], y: @origin[:y], z: @origin[:z] + @width }
  end

  def front_bottom_right_coordinates
    { x: @origin[:x] + @length, y: @origin[:y], z: @origin[:z] + @width }
  end

  def front_top_left_coordinates
    { x: @origin[:x], y: @origin[:y] + @height, z: @origin[:z] + @width }
  end

  def front_top_right_coordinates
    { x: @origin[:x] + @length, y: @origin[:y] + @height, z: @origin[:z] + @width }
  end
  
  def rear_bottom_left_coordinates
    { x: @origin[:x], y: @origin[:y], z: @origin[:z] }
  end

  def rear_bottom_right_coordinates
    { x: @origin[:x] + @length, y: @origin[:y], z: @origin[:z] }
  end

  def rear_top_left_coordinates
    { x: @origin[:x], y: @origin[:y] + @height, z: @origin[:z] }
  end

  def rear_top_right_coordinates
    { x: @origin[:x] + @length, y: @origin[:y] + @height, z: @origin[:z] }
  end
end

