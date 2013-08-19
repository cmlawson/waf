# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'waf/version'

Gem::Specification.new do |gem|
  gem.name          = "waf"
  gem.version       = Waf::VERSION
  gem.authors       = ["Colin"]
  gem.email         = ["colin.m.lawson@gmail.com"]
  gem.description   = %q{all gems for backend - WAF}
  gem.summary       = %q{get album info from api's, scraping. Also clean data!}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.files         += Dir.glob("lib/**/*.rb")
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rake'
  gem.add_dependency 'thin'
  gem.add_dependency 'json'
  gem.add_dependency 'require_all'
  gem.add_dependency 'resque'
  gem.add_dependency 'god'
  gem.add_dependency 'mysql2'
  gem.add_dependency 'net-ssh-gateway'
  gem.add_dependency 'mechanize'
  gem.add_dependency 'sanitize'

  gem.add_development_dependency 'awesome_print'
end
