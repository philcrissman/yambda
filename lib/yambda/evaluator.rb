module Yambda
  class Evaluator
    def initialize(global_env)
      @global_env = global_env
    end

    def eval(x, env = @global_env)
      if x.is_a?(Symbol)
        env.lookup(x)
      elsif x.is_a?(Array)
        eval(::Yambda::Parser.convert_to_cons(x))
      elsif !x.is_a?(::Yambda::Cons)
        x
      else
        case x.car
        when :define
          _, var, exp = list_to_array(x)
          env[var] = eval(::Yambda::Parser.convert_to_cons(exp), env)
        when :quote
          # binding.pry
          if x.cdr.car.nil?
            ::Yambda::EmptyList.new
          else
            x.cdr.car.to_s
          end
        when :lambda
          # make a lambda
          l = ::Yambda::Lambda.new(env,
                                   ::Yambda::Parser.convert_to_cons(x.cdr.car),
                                   ::Yambda::Parser.convert_to_cons(x.cdr.cdr.car))
          # return the lambda
          l
          # ... that's it?
        when :if
          _, cond, thendo, elsedo = list_to_array(x)
          condval = eval(cond, env)
          condval ? eval(thendo) : eval(elsedo)
        else
          # it's special cases all the way down, Bob!
          # binding.pry
          if x.is_a?(Array)
            x = ::Yambda::Parser.convert_to_cons(x)
          end
          proc = eval(x.car, env)
          unless x.cdr.is_a?(::Yambda::EmptyList)
            if x.cdr.car.is_a?(Symbol) && env.lookup(x.cdr.car).is_a?(Proc)
              evald_cdr = eval(x.cdr, env)
            else
              evald_cdr = x.cdr
            end
            args = list_to_array(evald_cdr).map{|arg| eval(arg, env)}
          else
            args = []
          end
          return proc unless proc.respond_to?(:call)
          proc.call(*args)
        end
      end
    end

    def list_to_array(lst)
      if lst.respond_to?(:to_a)
        lst.to_a
      else
        lst
      end
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