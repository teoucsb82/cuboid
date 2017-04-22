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
    it { expect(cuboid.move_to!(1,2,3)).to be true }
    
    it "changes the origin in the simple happy case" do
      cuboid.move_to!(1,2,3)
      expect(cuboid.origin).to eq({x: 1, y: 2, z: 3})
    end

  end    
  
  describe "intersects?" do
  end

end
