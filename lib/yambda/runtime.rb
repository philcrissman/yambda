module Yambda
  class Runtime
    def initialize
      @global_env = ::Yambda::Environment.new

      @global_env.update({
        :+ => ->(x, y){ x + y },
        :- => ->(x, y){ x - y },
        :* => ->(x, y){ x * y },
        :/ => ->(x , y){ x / y },
        :car => ->(x){ x.car },
        :cdr => ->(x){ x.cdr },
        :cons => ->(x, y){ ::Yambda::Cons.new(x, y) },
        :pair? => ->(x){ x.is_a?(Cons) },
        :null? => ->(x){ x.nil? }
                         })
      @parser = ::Yambda::Parser.new
      @evaluator = ::Yambda::Evaluator.new(@global_env)
    end

    def run(text)
      expressions = @parser.parse(text)

      @evaluator.eval_all(expressions)
    end

    def repl
      puts "YAMBDA YAMBDA YAMBDA"
      input = "nothing yet"
      while input != "exit"
        print "> "
        input = gets
        break if input == "exit\n"
        puts run(input)
      end
    end
  end
end