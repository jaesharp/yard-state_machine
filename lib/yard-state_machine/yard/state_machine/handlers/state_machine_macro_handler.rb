require 'yard'

module YARD
  module StateMachine
    module Handlers

      # Handles and processes the #state_machine macro
      class StateMachineMacroHandler < ::YARD::Handlers::Ruby::Base

        handles method_call(:state_machine)
        namespace_only

        def process
          macro = extract_macro(statement)
          decorate_macro_with_description macro
          append_state_machine_to_namespace macro
        end

        private

        def extract_macro from_statement
          state_machine_name_ast, state_machine_options_ast = from_statement.parameters

          return {
            :type => :state_machine_macro,
            :name => extract_string_or_symbol_name(state_machine_name_ast),
            :namespace => namespace,
            :options => extract_hash_from_ast(state_machine_options_ast),
            :description => {
            }
          }
        end

        def extract_string_or_symbol_name ast
          raise 'symbol expected (state_machine name) as first argument to state_machine' unless ast.type == :symbol_literal

          # tstring_content/ident nodes in the ruby AST represent the content of strings and symbols
          ast.jump(:tstring_content, :ident).source
        end

        def extract_hash_from_ast ast
          return nil unless ast
          raise 'hash expected (state_machine macro options) as second argument to state_machine' unless ast.children.all?{|node| node.type == :assoc}

          options_hash = Hash.new
          ast.children.each do |assoc|
            key = assoc[0].jump(:ident).source.to_sym
            value = assoc[1].source
            options_hash[key] = value
          end
          return options_hash
        end

        def decorate_macro_with_description for_macro
          parse_block statement.last.last, :owner => for_macro
        end

        def append_state_machine_to_namespace macro
          namespace['state_machine_state_machines'] ||= Hash.new
          namespace['state_machine_state_machines'][macro[:name]] = macro
        end

      end

    end
  end
end
