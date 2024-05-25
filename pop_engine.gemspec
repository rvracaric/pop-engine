lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'pop_engine/version'

Gem::Specification.new do |spec|
  spec.name        = 'pop_engine'
  spec.version     = PopEngine::VERSION
  spec.authors     = ['TalentNest']
  spec.email       = ['support@talentnest.com']
  spec.summary     = 'Ruby wrapper around the POP Engine API.'
  spec.description = 'Interact with the POP Engine API using Ruby.'
  spec.homepage    = 'https://github.com/talentnest/pop-engine'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.0.0'

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/}) ||
      f.match(%r{^\.gitignore$}) ||
      f.match(%r{^\.rspec$}) ||
      f.match(%r{^\.travis\.yml$}) ||
      f.match(%r{^Gemfile(\.lock)?$})
    end
  end

  spec.require_paths = ['lib']

  spec.metadata['source_code_uri'] = 'https://github.com/talentnest/pop-engine'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/talentnest/pop-engine/issues'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'json', '~> 2.0'
  spec.add_dependency 'faraday', '>= 0.9', '< 3.0'
end
