# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capistrano-scm-localgitcopy"
  s.version     = "0.2.0"
  s.licenses    = ["MIT"]
  s.authors     = ["Tom Hanoldt"]
  s.email       = ["tom@creative-workflow.berlin"]
  s.homepage    = "https://github.com/creative-workflow/capistrano-scm-localgitcopy"
  s.summary     = %q{A copy strategy for Capistrano 3, which uses `git ls-files` local, tars the files, uploads and extracts.}
  s.description = %q{A copy strategy for Capistrano 3, which uses `git ls-files` local, tars the files, uploads and extracts.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "capistrano", "~> 3.0"
end
