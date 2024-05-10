lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "pop_engine/version"

Gem::Specification.new do |spec|
  spec.name        = "pop_engine"
  spec.version     = PopEngine::VERSION
  spec.authors     = ["TalentNest"]
  spec.email       = ["support@talentnest.com"]

  spec.summary     = 'Ruby wrapper around the POPEngine API.'
  spec.description = 'Interact with the POP Engine API using Ruby.'
  spec.license     = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'faraday', '~> 1.10.3'
end
