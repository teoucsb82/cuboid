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
    let(:cuboid_1_origin) { { x: 0, y: 0, z: 0 } } 
    let(:cuboid_1_length) { 10 }
    let(:cuboid_1_width) { 10 }
    let(:cuboid_1_height) { 10 }
    let(:cuboid_1) { Cuboid.new(cuboid_1_origin, cuboid_1_length, cuboid_1_width, cuboid_1_height) }

    let(:cuboid_2_length) { 5 }
    let(:cuboid_2_width) { 5 }
    let(:cuboid_2_height) { 5 }
    let(:cuboid_2) { Cuboid.new(cuboid_2_origin, cuboid_2_length, cuboid_2_width, cuboid_2_height) }

    context 'totally separate cuboids' do
      let(:cuboid_2_origin) { { x: 99, y: 99, z: 99 } } 

      it { expect(cuboid_1.intersects?(cuboid_2)).to eq false }
      it { expect(cuboid_2.intersects?(cuboid_1)).to eq false }
    end

    context 'adjacent cuboids' do
      context 'end to end cuboids' do
        let(:cuboid_2_origin) { { x: cuboid_1_length, y: 0, z: 0 } } 

        it { expect(cuboid_1.intersects?(cuboid_2)).to eq false }
        it { expect(cuboid_2.intersects?(cuboid_1)).to eq false }
      end

      context 'side by side cuboids' do
        let(:cuboid_2_origin) { { x: 0, y: 0, z: cuboid_1_width } } 

        it { expect(cuboid_1.intersects?(cuboid_2)).to eq false }
        it { expect(cuboid_2.intersects?(cuboid_1)).to eq false }
      end

      context 'vertically stacked cuboids' do
        let(:cuboid_2_origin) { { x: 0, y: cuboid_1_height, z: 0 } } 

        it { expect(cuboid_1.intersects?(cuboid_2)).to eq false }
        it { expect(cuboid_2.intersects?(cuboid_1)).to eq false }
      end
    end

    context 'overlapping cuboids' do
      let(:cuboid_2_origin) { { x: 1, y: 1, z: 1 } } 
      
      it { expect(cuboid_1.intersects?(cuboid_2)).to eq true }
      it { expect(cuboid_2.intersects?(cuboid_1)).to eq true }
    end

    context 'one cuboid inside another' do
      let(:cuboid_1_origin) { { x: 0, y: 0, z: 0 } } 
      let(:cuboid_2_origin) { { x: 2, y: 2, z: 2 } } 

      it { expect(cuboid_1.intersects?(cuboid_2)).to eq true }
      it { expect(cuboid_2.intersects?(cuboid_1)).to eq true }
    end
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
