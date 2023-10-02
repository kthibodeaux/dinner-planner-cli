lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'dinner-planner-cli'
  spec.summary       = 'A command line recipe manager, dinner planner, and shopping list generator.'
  spec.version       = '0.0.1'
  spec.authors       = ['Keith Thibodeaux']
  spec.licenses      = %w[MIT]

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'matrix', '~> 0.4'
  spec.add_runtime_dependency 'toml'

  spec.add_development_dependency 'bundler', '~> 2.3'
end
