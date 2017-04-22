require 'cuboid'

#This test is incomplete and, in fact, won't even run without errors.  
#  Do whatever you need to do to make it work and please add your own test cases for as many
#  methods as you feel need coverage
describe Cuboid do
  let(:origin) { { x: 0, y: 0, z: 0 }}
  let(:length) { 3 }
  let(:width) { 4 }
  let(:height) { 5 }
  
  let(:cuboid) { Cuboid.new(origin, length, width, height) }

  describe "#move_to!" do
    it 'returns true in the simple happy case' do
      expect(cuboid.move_to!(1,2,3)).to be true
    end
    
    it "changes the origin in the simple happy case" do
      cuboid.move_to!(1,2,3)
      expect(cuboid.origin).to eq({x: 1, y: 2, z: 3})
    end

    context 'invalid arguments' do
      it 'raises an error if any coordinates are out of bounds' do
        expect { cuboid.move_to!(0,0,-1) }.to raise_error StandardError, 'Coordinates must be positive'
      end

      it 'raises an error if any coordinates are not integers' do
        expect { cuboid.move_to!('some', 'fance', 'coordinate') }.to raise_error StandardError, 'Coordinates must be integers'
      end
    end
  end    
  
  describe "intersects?" do
  end

  describe "vertices" do
    it 'returns an array of hashed coordinates' do
      expect(cuboid.vertices).to eq(
      [
        { x: 0, y: 0, z: 0 },
        { x: 3, y: 0, z: 0 },
        { x: 0, y: 0, z: 4 },
        { x: 3, y: 0, z: 4 },
        { x: 0, y: 5, z: 0 },
        { x: 3, y: 5, z: 0 },
        { x: 0, y: 5, z: 4 },
        { x: 3, y: 5, z: 4 }
      ])
    end
  end
end
