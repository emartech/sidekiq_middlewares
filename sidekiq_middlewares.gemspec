# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq_middlewares/version'

Gem::Specification.new do |spec|
  spec.name                  = 'sidekiq_middlewares'
  spec.version               = SidekiqMiddlewares::VERSION
  spec.authors               = ['Emarsys Smart Insight Team']
  spec.email                 = ['smart-insight-dev@emarsys.com']
  spec.license               = 'MIT'

  spec.summary               = 'Commonly reused Sidekiq Middlewares such as Benchmarker'
  spec.description           = 'Commonly reused Sidekiq Middlewares such as Benchmarker'
  spec.homepage              = 'https://github.com/emartech/sidekiq_middlewares'
  spec.required_ruby_version = ">= 2.2.2"

  spec.files                 = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir                = 'exe'
  spec.executables           = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths         = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
