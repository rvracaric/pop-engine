require 'ostruct'

module PopEngine
  class Object < OpenStruct
    def self.alias_attrib_names(alias_map = {})
      # Creates alternative names for object attributes.
      # Used where the API returns attributes with names that could be more user-friendly.
      # The original attribute names are not affected.

      alias_map.each do |alias_name, original_name|
        self.send(:define_method, alias_name) { send(original_name) }
      end
    end

    alias_attrib_names from_command: :command_from

    def initialize(attrs = {})
      super to_ostruct(attrs)
    end

    def to_ostruct(obj)
      case obj
      when Hash
        obj.each{ |key, value| obj[key] = to_ostruct(value) }
        OpenStruct.new(obj)
      when Array
        obj.map { |value| to_ostruct(value) }
      else
        obj
      end
    end
  end
end
