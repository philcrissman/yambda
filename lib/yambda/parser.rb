module Yambda
  class Parser
    def initialize
      @tokenizer = Tokenizer.new
    end

    def parse(program)
      tokens = @tokenizer.tokenize(program)
      expressions = []
      while !tokens.empty?
        expressions << read_from_tokens(tokens)
      end
      expressions
    end

    def self.convert_to_cons(lst)
      return lst unless lst.is_a?(Array)
      return nil if lst.empty?
      Cons.new(lst.first, convert_to_cons(lst[1..-1]))
    end

    def convert_to_cons(lst)
      self.class.convert_to_cons(lst)
    end

    def read_from_tokens(tokens)
      raise SyntaxError, "Unexpected EOF" if tokens.empty?

      token = tokens.shift
      case token
      when '('
        list = []
        # hey, look at us looking at the next token. Are we a look-ahead parser now?
        quoted_exp = (tokens[0] == 'quote')
        until tokens[0] == ')'
          list << read_from_tokens(tokens)
        end
        tokens.shift # pop off the ')'
        if quoted_exp
          # if this expression was quoted, we just want to return the cons cells of reading the expression,
          # not add another cons cell around it.
          list.first
        else
          convert_to_cons(list)
        end
      when 'quote'
        quoted_expr = read_from_tokens(tokens)
        convert_to_cons([:quote, quoted_expr])
      when ')'
        raise SyntaxError, "Unexpected ')'"
      else
        atom(token)
      end
    end

    def atom(token)
      Integer(token)
    rescue
      token.to_sym
    end
  end
end