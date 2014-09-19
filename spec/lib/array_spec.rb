require_relative '../../lib/array'

describe 'Array#jenks' do
  context 'with an empty array' do
    it 'returns an array with nil, with no breaks' do
      expect([].jenks(0)).to eql [nil]
    end

    it 'returns nil with one break' do
      expect([].jenks(1)).to eql nil
    end

    it 'returns nil with multiple breaks' do
      expect([].jenks(2)).to eql nil
    end
  end

  context 'with an array of one element' do
    it 'returns an array of one with no breaks' do
      expect([1].jenks(0)).to eql [1]
    end

    it 'returns an array of [1,1] with one break' do
      expect([1].jenks(1)).to eql [1, 1]
    end

    it 'returns nil with multiple breaks' do
      expect([1].jenks(2)).to eql nil
    end
  end

  context 'with a big array' do
    let(:data) { (1..20).to_a + (41..60).to_a + (81..100).to_a }
    it 'returns nil with no breaks' do
      expect(data.jenks(0)).to eql [1]
    end

    it 'returns an array of [1,1] with one break' do
      expect(data.jenks(1)).to eql [1, 100]
    end

    it 'returns nil with multiple breaks' do
      expect(data.jenks(3)).to eql [1, 20, 60, 100] # jackpot
    end
  end
end
