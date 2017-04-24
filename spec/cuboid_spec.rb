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
    context 'invalid origin' do
      it { expect { Cuboid.new(0, length, width, height) }.to raise_error StandardError, 'Origin must be a hash' }
      it { expect { Cuboid.new({}, length, width, height) }.to raise_error StandardError, 'Origin must include x, y, and z coordinates' }
      it { expect { Cuboid.new({ x: 0, y: :bar, z: nil }, length, width, height) }.to raise_error StandardError, 'Origin coordinates must be numeric' }
    end

    context 'all dimensions must be positive & numeric' do
      describe 'invalid length' do
        it { expect { Cuboid.new(origin, 0, width, height) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
      end

      describe 'invalid width' do
        it { expect { Cuboid.new(origin, length, 0, height) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
      end

      describe 'invalid height' do
        it { expect { Cuboid.new(origin, length, width, 0) }.to raise_error StandardError, 'Dimensions must be positive real numbers' }
      end
    end
  end

  describe '#rotate!' do
    it 'returns true in the simple happy case' do
      floating_cuboid = Cuboid.new({x: 5, y: 5, z: 5}, length, width, height)
      expect(floating_cuboid.rotate!(:up)).to be true
    end

    it 'only accepts 6 directions' do
      expect { cuboid.rotate!(:foo) }.to raise_error StandardError, 'Direction must be in [:up, :down, :left, :right, :clockwise, :counterclockwise]'
    end

    context 'rotating outside of the box' do
      it 'resets origin, length, width and height to starting positions if rotate! fails' do
        %i[up down left right clockwise counterclockwise].each do |direction|
          expect{cuboid.rotate!(direction)}.to raise_error StandardError, 'Cannot rotate into negative coordinates.'
          expect(cuboid.instance_variable_get(:@length)).to eq(3)
          expect(cuboid.instance_variable_get(:@width)).to eq(4)
          expect(cuboid.instance_variable_get(:@height)).to eq(5)
          expect(cuboid.instance_variable_get(:@origin)).to eq(x: 0, y: 0, z: 0)
        end
      end
    end

    describe 'modifies the origin, length, width, and height to account for direction of turn' do
      let(:origin) { { x: 10, y: 10, z: 10 } }

      it 'rotates up' do
        cuboid.rotate!(:up)
        expect(cuboid.instance_variable_get(:@length)).to eq(5)
        expect(cuboid.instance_variable_get(:@width)).to eq(4)
        expect(cuboid.instance_variable_get(:@height)).to eq(3)
        expect(cuboid.instance_variable_get(:@origin)).to eq(x: 10 - height, y: 10, z: 10)
      end

      it 'rotates down' do
        cuboid.rotate!(:down)
        expect(cuboid.instance_variable_get(:@length)).to eq(5)
        expect(cuboid.instance_variable_get(:@width)).to eq(4)
        expect(cuboid.instance_variable_get(:@height)).to eq(3)
        expect(cuboid.instance_variable_get(:@origin)).to eq(x: 10, y: 10, z: 10 - length)
      end

      it 'rotates left' do
        cuboid.rotate!(:left)
        expect(cuboid.instance_variable_get(:@length)).to eq(4)
        expect(cuboid.instance_variable_get(:@width)).to eq(3)
        expect(cuboid.instance_variable_get(:@height)).to eq(5)
        expect(cuboid.instance_variable_get(:@origin)).to eq(x: 10, y: 10 - length, z: 10)
      end

      it 'rotates right' do
        cuboid.rotate!(:right)
        expect(cuboid.instance_variable_get(:@length)).to eq(4)
        expect(cuboid.instance_variable_get(:@width)).to eq(3)
        expect(cuboid.instance_variable_get(:@height)).to eq(5)
        expect(cuboid.instance_variable_get(:@origin)).to eq(x: 10 - width, y: 10, z: 10)
      end

      it 'rotates clockwise' do
        cuboid.rotate!(:clockwise)
        expect(cuboid.instance_variable_get(:@length)).to eq(3)
        expect(cuboid.instance_variable_get(:@width)).to eq(5)
        expect(cuboid.instance_variable_get(:@height)).to eq(4)
        expect(cuboid.instance_variable_get(:@origin)).to eq(x: 10, y: 10, z: 10 - width)
      end

      it 'rotates counterclockwise' do
        cuboid.rotate!(:counterclockwise)
        expect(cuboid.instance_variable_get(:@length)).to eq(3)
        expect(cuboid.instance_variable_get(:@width)).to eq(5)
        expect(cuboid.instance_variable_get(:@height)).to eq(4)
        expect(cuboid.instance_variable_get(:@origin)).to eq(x: 10, y: 10 - height, z: 10)
      end
    end
  end

  describe '#move_to!' do
    it 'returns true in the simple happy case' do
      expect(cuboid.move_to!(1, 2, 3)).to be true
    end

    it 'changes the origin in the simple happy case' do
      cuboid.move_to!(1, 2, 3)
      expect(cuboid.instance_variable_get(:@origin)).to eq(x: 1, y: 2, z: 3)
    end

    context 'invalid arguments' do
      it 'raises an error if any coordinates are not integers' do
        expect { cuboid.move_to!('some', 'fancy', 'coordinate') }.to raise_error StandardError, 'Origin coordinates must be numeric'
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
      # Imagine a 10x10" wooden square 1" thick magically floating 5" above the ground.
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
