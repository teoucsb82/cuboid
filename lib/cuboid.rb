require 'pry'
##
# This class represents an arbitrary rectangular cuboid by origin and dimensions.

class Cuboid
  # BEGIN public methods that should be your starting point
  def initialize(origin = {}, length, width, height)
    @origin = origin
    @length = length
    @width = width
    @height = height
    validate_origin
    validate_dimensions
  end

  # returns true if the two cuboids intersect each other.  False otherwise.
  def intersects?(other)
    any_corners_inside?(other) || other.any_corners_inside?(self) ||
      any_edges_inside?(other) || other.any_edges_inside?(self) ||
      identical_dimensions?(other)
  end

  def move_to!(x, y, z)
    @origin = { x: x, y: y, z: z }
    validate_origin
  end

  def rotate!(direction_sym)
    @direction = direction_sym
    validate_direction
    case @direction
    when :up then rotate_up
    when :down then rotate_down
    when :left then rotate_left
    when :right then rotate_right
    when :clockwise then rotate_clockwise
    when :counterclockwise then rotate_counterclockwise
    end
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
  # END public methods that should be your starting point

  protected

  def any_corners_inside?(other)
    set_coordinates(other)
    # return true if any of the 8 edges are inside the other cuboid
    vertices.any? do |coords|
      coords[:x] > @x_coords.min && coords[:x] < @x_coords.max &&
        coords[:y] > @y_coords.min && coords[:y] < @y_coords.max &&
        coords[:z] > @z_coords.min && coords[:z] < @z_coords.max
    end
  end

  def any_edges_inside?(other)
    set_coordinates(other)
    xy_edges_inside? || xz_edges_inside? || yz_edges_inside?
  end

  def identical_dimensions?(other)
    vertices == other.vertices
  end

  def set_coordinates(other)
    @x_coords = other.vertices.map { |coord| coord[:x] }
    @y_coords = other.vertices.map { |coord| coord[:y] }
    @z_coords = other.vertices.map { |coord| coord[:z] }
  end

  private

  def all_dimensions_are_positive_numbers?
    [@length, @width, @height].all? { |dimension| dimension.is_a?(Numeric) && dimension > 0 }
  end

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

  def origin_coordinates_are_numeric?
    [@origin[:x], @origin[:y], @origin[:z]].all? { |coord| coord.is_a?(Numeric) }
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

  def rotate_clockwise
    raise 'Cannot rotate into negative coordinates.' if @origin[:z] - @width < 0
    @origin[:z] -= @width
    swap_height_width
  end

  def rotate_counterclockwise
    raise 'Cannot rotate into negative coordinates.' if @origin[:y] - @height < 0
    @origin[:y] -= @height
    swap_height_width
  end

  def rotate_down
    raise 'Cannot rotate into negative coordinates.' if @origin[:z] - @length < 0
    @origin[:z] -= @length
    swap_length_height
  end

  def rotate_left
    raise 'Cannot rotate into negative coordinates.' if @origin[:y] - @length < 0
    @origin[:y] -= @length
    swap_length_width
  end

  def rotate_right
    raise 'Cannot rotate into negative coordinates.' if @origin[:x] - @width < 0
    @origin[:x] -= @width
    swap_length_width
  end

  def rotate_up
    raise 'Cannot rotate into negative coordinates.' if @origin[:x] - @height < 0
    @origin[:x] -= @height
    swap_length_height
  end

  def swap_length_height
    @length, @height = @height, @length
  end

  def swap_length_width
    @length, @width = @width, @length
  end

  def swap_height_width
    @height, @width = @width, @height
  end

  def validate_dimensions
    raise 'Dimensions must be positive real numbers' unless all_dimensions_are_positive_numbers?
    true
  end

  def validate_direction
    valid_directions = %i[up down left right clockwise counterclockwise]
    raise "Direction must be in #{valid_directions}" unless valid_directions.include?(@direction)
    true
  end

  def validate_origin
    raise 'Origin must be a hash' unless @origin.is_a?(Hash)
    raise 'Origin must include x, y, and z coordinates' unless %i[x y z].all? { |k| @origin.key?(k) }
    raise 'Origin coordinates must be numeric' unless origin_coordinates_are_numeric?
    true
  end

  def xy_edges
    [
      [rear_bottom_left_coordinates, front_bottom_left_coordinates],
      [rear_bottom_right_coordinates, front_bottom_right_coordinates],
      [rear_top_left_coordinates, front_top_left_coordinates],
      [rear_top_right_coordinates, front_top_right_coordinates]
    ]
  end

  def xy_edges_inside?
    xy_edges.any? do |edge|
      current_x = edge.detect { |coord| coord[:x] }[:x]
      current_y = edge.detect { |coord| coord[:y] }[:y]
      z_min = edge.map { |coord| coord[:z] }.min
      z_max = edge.map { |coord| coord[:z] }.max
      current_x > @x_coords.min && current_x < @x_coords.max &&
        current_y > @y_coords.min && current_y < @y_coords.max &&
        z_min < @z_coords.max && z_max > @z_coords.max
    end
  end

  def xz_edges
    [
      [rear_bottom_left_coordinates, rear_top_left_coordinates],
      [rear_bottom_right_coordinates, rear_top_right_coordinates],
      [front_bottom_left_coordinates, front_top_left_coordinates],
      [front_bottom_right_coordinates, front_top_right_coordinates]
    ]
  end

  def xz_edges_inside?
    xz_edges.any? do |edge|
      current_x = edge.detect { |coord| coord[:x] }[:x]
      current_z = edge.detect { |coord| coord[:z] }[:z]
      y_min = edge.map { |coord| coord[:y] }.min
      y_max = edge.map { |coord| coord[:y] }.max
      current_x > @x_coords.min && current_x < @x_coords.max &&
        current_z > @z_coords.min && current_z < @z_coords.max &&
        y_min < @y_coords.max && y_max > @y_coords.max
    end
  end

  def yz_edges
    [
      [rear_bottom_left_coordinates, rear_bottom_right_coordinates],
      [front_bottom_left_coordinates, front_bottom_right_coordinates],
      [rear_top_left_coordinates, rear_top_right_coordinates],
      [front_top_left_coordinates, front_top_right_coordinates]
    ]
  end

  def yz_edges_inside?
    yz_edges.any? do |edge|
      current_y = edge.detect { |coord| coord[:y] }[:y]
      current_z = edge.detect { |coord| coord[:z] }[:z]
      x_min = edge.map { |coord| coord[:x] }.min
      x_max = edge.map { |coord| coord[:x] }.max
      current_y > @y_coords.min && current_y < @y_coords.max &&
        current_z > @z_coords.min && current_z < @z_coords.max &&
        x_min < @x_coords.max && x_max > @x_coords.max
    end
  end
end
