# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kim-logger/version"

Gem::Specification.new do |s|
  s.name        = "kim-logger"
  s.version     = Kim::Logger::VERSION
  s.authors     = ["Giancarlo Palavicini"]
  s.email       = ["kasthor@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Improves standard logger to add multiple devices}
  s.description = %q{Some improvements to add multiple devices for logger as well as adding an e-mail device}

  s.rubyforge_project = "kim-logger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'kim'
end
