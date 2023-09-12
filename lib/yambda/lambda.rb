module Yambda
  class Lambda
    def initialize(env, args, expression)
      @env = ::Yambda::Environment.new(env)
      @args = args
      @expression = expression
      @evaluator = ::Yambda::Evaluator.new(@env)
    end

    def call(*args)
      arg = @args
      while !arg.nil?
        argval = args.shift
        raise StandardError, "Wrong number of arguments" if argval.nil?
        @env.merge!({arg.car => argval})
        arg = arg.cdr
      end
      if !args.empty?
        raise StandardError, "Too many arguments!"
      end
      @evaluator.eval(@expression, @env)
    end
  end
end