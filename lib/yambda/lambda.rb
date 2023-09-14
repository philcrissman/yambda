module Yambda
  class Lambda
    def initialize(env, args, expression)
      @env = ::Yambda::Environment.new(env)
      if args.is_a?(Array)
        args = ::Yambda::Parser.convert_to_cons(args)
      end
      @args = args
      @expression = expression
      @evaluator = ::Yambda::Evaluator.new(@env)
    end

    def call(*args)
      arg = @args
      while !arg.nil?
        argval = args.shift
        # binding.pry
        unless argval.is_a?(::Yambda::EmptyList)
          raise StandardError, "Wrong number of arguments" if argval.nil?
        end
        @env.merge!({arg.car => argval})
        arg = arg.cdr
      end
      if !args.empty?
        raise StandardError, "Too many arguments!"
      end
      @evaluator.eval(@expression, @env)
    end

    def to_s
      "#<procedure>"
    end
  end
end