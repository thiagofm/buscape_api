$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "buscape_api"
  s.version     = "0.5"
  s.email       = ["t@art-is-t.me"]
  s.authors     = ["Thiago Fernandes Massa"]
  s.homepage    = "http://github.com/thiagofm/buscape_api"
  s.summary     = %q{Buscape API wrapper}
  s.description = %q{A Buscape API wrapper}

  s.rubyforge_project = "buscape_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("httparty", ">= 0.8.3")
end