# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gitconfig/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Maciej Pasternacki"]
  gem.email         = ["maciej@pasternacki.net"]
  gem.description   = "Keep your local configuration in git's config"
  gem.summary       = "Keep your local configuration in git's config"
  gem.homepage      = "https://github.com/mpasternacki/highline/"

  gem.files         = `git ls-files`.split($\).reject { |f| f =~ /highline/ }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gitconfig"
  gem.require_paths = ["lib"]
  gem.version       = GitConfig::VERSION

  gem.add_dependency('escape')
  gem.add_dependency('git')
end
