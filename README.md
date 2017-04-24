# Cuboid Quickstart

## Initializing a cuboid object
Requires an `origin` (hash), `length` (numeric), `width` (numeric) and `height` (numeric).
Assumptions: 

  - All dimensions (l/w/h) must be numeric and positive (no 2d objects, sorry). `origin` hash must contain `:x`, `:y` and `:z` keys.

```
origin = { x: 0, y: 0, z: 0 }
length = 3
width = 4
height = 5
cuboid = Cuboid.new(origin, length, width, height)

=> #<Cuboid:0x007fa00c8016b0 @origin={:x=>0, :y=>0, :z=>0}, @length=3, @width=4, @height=5>
```

## Obtaining cuboid vertices
Given a `cuboid` object, `#vertices` will return an array of 8 coordinates in x,y,z space

```
cuboid.vertices
=> [
    {:x=>0, :y=>0, :z=>0}, 
    {:x=>3, :y=>0, :z=>0}, 
    {:x=>0, :y=>0, :z=>4}, 
    {:x=>3, :y=>0, :z=>4}, 
    {:x=>0, :y=>5, :z=>0}, 
    {:x=>3, :y=>5, :z=>0}, 
    {:x=>0, :y=>5, :z=>4}, 
    {:x=>3, :y=>5, :z=>4}
   ]
```

## Checking if two objects intersect?
Assumptions: 

  - If one object encases another, (say, 1" square cube inside a 2" square cube), that counts as "intersecting" even though no edges overlap.

```
cuboid_2 = Cuboid.new(origin, length + 1, width + 1, height + 1)
cuboid_2.intersects?(cuboid)
=> true

cuboid_3 = Cuboid.new({x: 100, y: 100, z: 100}, length, width, height)
cuboid_3.intersects?(cuboid_2)
=> false

cuboid_3.intersects?(cuboid)
=> false
```

## Rotation
Assumptions: 

  - Cube can `#rotate!` in one of 6 directions --> `:up`, `:down`, `:left`, `:right`, `:clockwise` or `: counterclockwise`. 
  - Rotating a cuboid moves it around its original `origin`, and will return the same `cuboid` object with modified dimensions and `origin` depending on the direction.
  - Rotating a cube into negative `origin` coordinates (ex, if you started at `x: 0, y: 0, z:0`) will raise an error.


```
origin = { x: 10, y: 10, z: 10 }
length = 3
width = 4
height = 5
cuboid = Cuboid.new(origin, length, width, height)

=> #<Cuboid:0x007f98650257d8 @origin={:x=>10, :y=>10, :z=>10}, @length=3, @width=4, @height=5>

cuboid.rotate!(:up)
=> #<Cuboid:0x007f98650257d8 @origin={:x=>5, :y=>10, :z=>10}, @length=5, @width=4, @height=3>
```
