module Yambda
  class Environment < Hash
    def initialize(parent = nil)
      @parent = parent
    end

    def lookup(variable)
      return self[variable] if key?(variable)
      raise StandardError, "Unbound variable #{variable}" unless @parent
      @parent.lookup(variable)
    end
  end
end