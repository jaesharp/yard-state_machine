module YARD
  module StateMachine

    module Version
      MAJOR = '0'
      MINOR = '0'
      PATCH = '1'

      def self.to_standard_version_s
        return [MAJOR, MINOR, PATCH].join('.')
      end
    end

  end
end
