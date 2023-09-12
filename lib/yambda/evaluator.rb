module Yambda
  class Evaluator
    def initialize(global_env)
      @global_env = global_env
    end

    def eval(x, env = @global_env)
      if x.is_a?(Symbol)
        env.lookup(x)
      elsif !x.is_a?(::Yambda::Cons)
        x
      else
        case x.car
        when :define
          _, var, exp = list_to_array(x)
          env[var] = eval(::Yambda::Parser.convert_to_cons(exp), env)
        when :quote
          x.cdr.car.to_s
        when :lambda
          # make a lambda
          l = ::Yambda::Lambda.new(env, x.cdr.car, x.cdr.cdr)
          # return the lambda
          l
          # ... that's it?
        else
          # binding.pry
          proc = eval(x.car, env)
          args = list_to_array(x.cdr).map{|arg| eval(arg, env)}
          return proc unless proc.respond_to?(:call)
          proc.call(*args)
        end
      end
    end

    def list_to_array(lst)
      arr = []
      while lst
        arr << lst.car
        lst = lst.cdr
      end
      arr
    end

    def eval_all(expressions, env = @global_env)
      results = []
      expressions.each do |expression|
        results << eval(expression, env)
      end
      results.last # return the result of the last expression
    end
  end
end