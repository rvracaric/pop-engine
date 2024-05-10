module PopEngine
  class CustomFields < Object
    def initialize(attrs = {})
      # Creates a fields object with attributes:
      # fields.field1 == 'value1'
      # fields.field2 == 'value2'

      super to_single_hash(attrs)
    end

    private

    def to_single_hash(attrs)
      # Return a single hash: { 'field1' => 'value1', 'field2' => 'value2', ... }

      case attrs
      when Array
        # Convert an array of hashes: [{ 'field1' => 'value1' }, { 'field2' => 'value2' }, ...]
        attrs.reduce({}, :update)
      when String
        # Convert a pipe-separated string: 'field1|value1|field2|value2|...'
        attrs.split('|').each_slice(2).to_h
      else
        attrs
      end
    end
  end
end
