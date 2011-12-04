require 'yard'

module YARD
  module StateMachine
    module Handlers

      # Handles and processes the #state_machine macro
      class StateMachineEventHandler < ::YARD::Handlers::Ruby::Base

        handles method_call(:event)

        def process
          return unless called_within_state_machine_macro?

          event = extract_event_from_statement(statement)
          decorate_event_with_description event

          append_event_to_owner event

        end

        private

        def called_within_state_machine_macro?
          owner && owner.kind_of?(Hash) && owner.respond_to?(:[]) && owner[:type] == :state_machine_macro
        end

        def extract_event_from_statement statement
          return {
            :name => extract_event_name(statement.parameters),
            :type => :state_machine_event,
            :macro => owner,
            :description => {
            }
          }
        end

        def extract_event_name from_statement
          from_statement.jump(:ident, :tstring_content).source
        end

        def decorate_event_with_description event
          parse_block statement.last.last, :owner => event
        end

        def append_event_to_owner event
          owner[:description][:events] ||= Hash.new
          owner[:description][:events][event[:name].to_sym] = event
        end

      end

    end
  end
end

