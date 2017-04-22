class Cuboid
  attr_reader :origin
  attr_reader :dimensions
  
  #BEGIN public methods that should be your starting point
  def initialize(origin = {}, dimensions = {})
    @origin = origin
    @dimensions = dimensions
  end

  def move_to!(x, y, z)
    @origin[:x] = x
    @origin[:y] = y
    @origin[:z] = z
    true
  end
  
  def vertices
  end
  
  #returns true if the two cuboids intersect each other.  False otherwise.
  def intersects?(other)
  end

  #END public methods that should be your starting point  
end

