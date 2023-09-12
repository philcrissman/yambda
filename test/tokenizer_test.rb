# frozen_string_literal: true

require "test_helper"

class TokenizerTest < Minitest::Test

  def setup
    @tokenizer = ::Yambda::Tokenizer.new
  end

  def test_that_it_tokenizes
    assert_equal ["foo"], @tokenizer.tokenize("foo")
  end

  def test_tokenizing_a_number
    assert_equal ["42"], @tokenizer.tokenize("42")
  end

  def test_tokenizing_an_expression
    assert_equal ["(", "+", "2", "3", ")"], @tokenizer.tokenize("(+ 2 3)")
  end

  def test_tokenizing_an_actual_quote
    assert_equal ["(", "quote", "hello-world", ")"], @tokenizer.tokenize("(quote hello-world)")
  end

  def test_tokenizing_a_single_quoted_string
    assert_equal ["quote", "hello-world"], @tokenizer.tokenize("'hello-world")
  end

  def test_tokenizing_a_quoted_list
    assert_equal ["quote", "(", "1", "2", "3", ")"], @tokenizer.tokenize("'(1 2 3)")
  end
end