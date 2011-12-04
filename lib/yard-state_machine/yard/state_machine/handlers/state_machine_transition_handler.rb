require 'yard'

module YARD
  module StateMachine
    module Handlers

      # Handles and processes the #state_machine macro
      class StateMachineTransitionHandler < ::YARD::Handlers::Ruby::Base

        handles method_call(:transition)

        def process
          return unless called_within_state_machine_event?

          transition = extract_transition_from_statement(statement)

          append_transition_to_owner transition
        end

        private

        def called_within_state_machine_event?
          owner && owner.kind_of?(Hash) && owner.respond_to?(:[]) && owner[:type] == :state_machine_event
        end

        def extract_transition_from_statement statement
          transition_specifier = statement.parameters.first.jump(:assoc)

          raise 'expected first argument (transitions hash) to be a hash' unless transition_specifier.type == :assoc

          return {
            :type => :state_machine_transition,
            :event => owner,
            :from_states => extract_origin_states_from_parameters(transition_specifier),
            :to_state => extract_destination_states_from_parameters(transition_specifier)
          }
        end

        def extract_origin_states_from_parameters parameters
          keys = parameters[0]
          origin_states = case keys.type
            when :symbol_literal
              [ keys.jump(:ident).source.to_sym ]
            when :array
              keys.first.children.map do |obj| 
                raise "expected array hash key to contain only symbols (type encountered was '#{obj.type}')" unless obj.type == :symbol_literal
                obj.jump(:ident).source.to_sym
              end
            when :vcall
              keys.jump(:ident).source.to_sym
            else
              raise "unrecognized parameter type for transition hash key (type was '#{keys.type}')"
          end
        end

        def extract_destination_states_from_parameters parameters
          values = parameters[1]
          raise "unrecognized parameter type for transition hash value (type was '#{values.type}')" unless values.type == :symbol_literal
          values.jump(:ident).source.to_sym
        end

        def append_transition_to_owner transition
          owner[:description][:transitions] ||= Array.new
          owner[:description][:transitions] << transition
        end

      end

    end
  end
end

