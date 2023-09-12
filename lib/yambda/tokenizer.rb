module Yambda
  class Tokenizer

    def tokenize(chars)
      chars.gsub('\'', ' quote ').gsub('(', ' ( ').gsub(')', ' ) ').split
    end
  end
end