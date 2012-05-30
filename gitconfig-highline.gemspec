# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gitconfig/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Maciej Pasternacki"]
  gem.email         = ["maciej@pasternacki.net"]
  gem.description   = "Highline integration for gitconfig"
  gem.summary       = "Highline integration for gitconfig"
  gem.homepage      = "https://github.com/mpasternacki/highline/"

  gem.files         = `git ls-files`.split($\).select { |f| f =~ /highline|LICENSE/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gitconfig-highline"
  gem.require_paths = ["lib"]
  gem.version       = GitConfig::VERSION

  gem.add_dependency('gitconfig', GitConfig::VERSION)
  gem.add_dependency('highline')
end
