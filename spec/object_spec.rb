require 'spec_helper'

RSpec.describe PopEngine::Object do
  it 'should be successfully created from a hash' do
    object = described_class.new(foo: 'bar')
    expect(object.foo).to eq 'bar'
  end

  it 'should handle a nested hash' do
    object = described_class.new(foo: { bar: { baz: 'foobar' } })
    expect(object.foo.bar.baz).to eq 'foobar'
  end

  it 'should handle array' do
    object = described_class.new(foo: [{ bar: :baz }])

    expect(object.foo.first.class).to eq OpenStruct
    expect(object.foo.first.bar).to eq :baz
  end

  it 'should handle numbers' do
    object = described_class.new(foo: { bar: 1 })
    expect(object.foo.bar).to eq 1
  end
end
