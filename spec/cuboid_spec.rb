require 'cuboid'

# This test is incomplete and, in fact, won't even run without errors.
#  Do whatever you need to do to make it work and please add your own test cases for as many
#  methods as you feel need coverage
describe Cuboid do
  let(:origin) { { x: 0, y: 0, z: 0 } }
  let(:length) { 3 }
  let(:width) { 4 }
  let(:height) { 5 }

  let(:cuboid) { Cuboid.new(origin, length, width, height) }

  describe '#initialize' do
    context 'happy case with origin (hash), length (numeric), width (numeric), height (numeric)' do
      it { expect { Cuboid.new(origin, length, width, height) }.not_to raise_error }
    end

    context 'invalid origin' do
      it { expect { Cuboid.new('foo', length, width, height) }.to raise_error StandardError, 'Origin must be a hash' }
      it { expect { Cuboid.new({}, length, width, height) }.to raise_error StandardError, 'Origin must include x, y, and z coordinates' }
    end

    context 'all dimensions must be positive & numeric' do
      describe 'invalid length' do
        it { expect { Cuboid.new(origin, 'foo', width, height) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
        it { expect { Cuboid.new(origin, 0, width, height) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
      end

      describe 'invalid width' do
        it { expect { Cuboid.new(origin, length, 'foo', height) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
        it { expect { Cuboid.new(origin, length, 0, height) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
      end

      describe 'invalid height' do
        it { expect { Cuboid.new(origin, length, width, 'foo') }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
        it { expect { Cuboid.new(origin, length, width, 0) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
      end
    end
  end

  describe '#move_to!' do
    it 'returns true in the simple happy case' do
      expect(cuboid.move_to!(1, 2, 3)).to be true
    end

    it 'changes the origin in the simple happy case' do
      cuboid.move_to!(1, 2, 3)
      expect(cuboid.origin).to eq(x: 1, y: 2, z: 3)
    end

    context 'invalid arguments' do
      it 'raises an error if any coordinates are not integers' do
        expect { cuboid.move_to!('some', 'fancy', 'coordinate') }.to raise_error StandardError, 'Origin coordinates must be numbers'
      end
    end
  end

  describe 'intersects?' do
    let(:cuboid_1_origin) { { x: 0, y: 0, z: 0 } }
    let(:cuboid_1_length) { 10 }
    let(:cuboid_1_width) { 10 }
    let(:cuboid_1_height) { 10 }
    let(:cuboid_1) { Cuboid.new(cuboid_1_origin, cuboid_1_length, cuboid_1_width, cuboid_1_height) }

    let(:cuboid_2_length) { 5 }
    let(:cuboid_2_width) { 5 }
    let(:cuboid_2_height) { 5 }
    let(:cuboid_2) { Cuboid.new(cuboid_2_origin, cuboid_2_length, cuboid_2_width, cuboid_2_height) }

    context 'totally separate cuboids in the simple happy case' do
      let(:cuboid_2_origin) { { x: 99, y: 99, z: 99 } }

      it { expect(cuboid_1.intersects?(cuboid_2)).to eq false }
      it { expect(cuboid_2.intersects?(cuboid_1)).to eq false }
    end

    # literal "edge"-cases ;) touching != intersecting
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

    context 'identical cuboids' do
      let(:cuboid_2_origin) { cuboid_1_origin }

      it { expect(cuboid_1.intersects?(cuboid_1)).to eq true }
      it { expect(cuboid_2.intersects?(cuboid_2)).to eq true }
    end

    context 'overlapping cuboids' do
      let(:cuboid_2_origin) { { x: 1, y: 1, z: 1 } }

      it { expect(cuboid_1.intersects?(cuboid_2)).to eq true }
      it { expect(cuboid_2.intersects?(cuboid_1)).to eq true }
    end

    context 'one cuboid encased by another' do
      # While one cuboid complete encasing another is not technically intersecting,
      # return true in this scenario to capture the spirit of the challenge.
      let(:cuboid_1_origin) { { x: 0, y: 0, z: 0 } }
      let(:cuboid_2_origin) { { x: 2, y: 2, z: 2 } }

      it { expect(cuboid_1.intersects?(cuboid_2)).to eq true }
      it { expect(cuboid_2.intersects?(cuboid_1)).to eq true }
    end

    context 'one cuboid sticking directly through another' do
      # imagine a 10x10" wooden square 1" thick magically floating 5" above the ground.
      # now imagine a steel rod, 10" tall and 1" square plunged directly down through the
      # middle of the board until it touches the ground. These items
      # are clearly intersecting, despite none of their vertices being
      # lodged inside the other. We have to check their intersecting
      # planes (where steel goes through wood) to get accurate results.
      let(:wooden_square) { Cuboid.new({ x: 0, y: 5, z: 0 }, 10, 10, 1) }
      let(:steel_rod) { Cuboid.new({ x: 5, y: 0, z: 5 }, 1, 1, 10) }

      it { expect(steel_rod.intersects?(wooden_square)).to eq true }
      it { expect(wooden_square.intersects?(steel_rod)).to eq true }
    end
  end

  describe 'vertices' do
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
        ]
      )
    end
  end
end
