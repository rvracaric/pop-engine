module PopEngine
  class Candidate < Object
    def self.null
      new(name: nil, email: nil)
    end
  end
end
