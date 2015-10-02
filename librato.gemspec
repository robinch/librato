# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'librato/version'

Gem::Specification.new do |s|
  s.name          = 'librato'
  s.version       = Librato::VERSION
  s.authors       = ['Sven Fuchs']
  s.email         = ['me@svenfuchs.com']
  s.homepage      = 'https://github.com/svenfuchs/librato'
  s.summary       = 'Simple cli tool for storing and syncing librato spaces.'
  s.description   = "#{s.summary}."
  s.license       = "MIT"

  s.files         = Dir["{gemfiles,lib,test}/**/**"] + %w(MIT-LICENSE README.md)
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.executables << 'librato'
end
