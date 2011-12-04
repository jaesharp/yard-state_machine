# -*- encoding: utf-8 -*-
require File.expand_path('./lib/yard-state_machine/yard/state_machine/version')

Gem::Specification.new do |gem|

  gem.name = 'yard-state_machine'
  gem.version = YARD::StateMachine::Version.to_standard_version_s

  gem.authors = ["Justin Lynn"]
  gem.email = ["justinlynn@gmail.com"]

  gem.summary = %q{A YARD Plugin for state_machine integration.}
  gem.description = %q{A YARD Plugin for state_machine integration. Automatically documents state_machine DSL defined state machines.}

  gem.homepage = 'https://github.com/justinlynn/yard-state_machine'

  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename f }
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split "\n"
  gem.files = `git ls-files`.split "\n"

  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9.3'
  gem.required_rubygems_version = Gem::Requirement.new '>= 1.8'

  gem.add_dependency 'yard', '~> 0.7.3'
  gem.add_dependency 'ruby-graphviz', '~> 1.0.0'
end
