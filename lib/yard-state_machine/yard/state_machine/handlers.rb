module YARD
  module StateMachine

    # YARD custom handlers for integrating the StateMachine DSL with the
    # YARD documentation system
    module Handlers
    end

  end
end

require 'yard-state_machine/yard/state_machine/handlers/state_machine_macro_handler'
require 'yard-state_machine/yard/state_machine/handlers/state_machine_event_handler'
require 'yard-state_machine/yard/state_machine/handlers/state_machine_transition_handler'
