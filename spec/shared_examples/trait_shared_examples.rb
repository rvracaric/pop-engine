RSpec.shared_examples_for 'a trait' do
  let(:trait_data) do
    {
      'trait_name' => 'Enterprising (ENT)',
      'caption_tr' => 'Enterprising Orientation',
      'score' => 147
    }
  end

  subject { described_class.new(trait_data) }

  it 'should have the given data' do
    expect(subject.trait_name).to eq 'Enterprising (ENT)'
    expect(subject.caption_tr).to eq 'Enterprising Orientation'
    expect(subject.score).to eq 147
  end

  it 'should have the aliased attributes as well' do
    expect(subject.name).to eq subject.trait_name
    expect(subject.title_tr).to eq subject.caption_tr
  end
end
