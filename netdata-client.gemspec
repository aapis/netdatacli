# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netdata/client/version'

Gem::Specification.new do |spec|
  spec.name          = "netdata-client"
  spec.version       = Netdata::Client::VERSION
  spec.authors       = ["Ryan Priebe"]
  spec.email         = ["rpriebe@me.com"]

  spec.summary       = "Monitor your netdata instances, spawn OS notifications"
  spec.homepage      = "http://github.com/aapis/netdata-client"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'notifaction'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
