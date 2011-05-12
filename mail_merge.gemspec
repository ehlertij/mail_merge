# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mail_merge/version"

Gem::Specification.new do |s|
  s.name        = "mail_merge"
  s.version     = MailMerge::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian Ehlert"]
  s.email       = ["ehlertij@gmail.com"]
  s.homepage    = "https://github.com/ehlertij/mail_merge"
  s.summary     = %q{Mail Merge Gem}
  s.description = %q{A simple gem that will perform a mail merge on a string based on merge fields provided.}

  s.rubyforge_project = "mail_merge"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
