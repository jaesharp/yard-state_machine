require 'yard'

state_machine_template_path = File.join(File.expand_path(File.dirname(__FILE__)), 'templates')
YARD::Templates::Engine.register_template_path state_machine_template_path
