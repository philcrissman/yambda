# frozen_string_literal: true

require "test_helper"

class ParserTest < Minitest::Test
  def setup
    @parser = ::Yambda::Parser.new
  end

  def test_parsing
    # assert_equal [[:+, 2, 3]], @parser.parse("(+ 2 3)")
    list = @parser.parse("(+ 2 3)")
    assert_equal ::Yambda::Cons, list.first.class
    assert_equal :+, list.first.car
    assert_equal 2, list.first.cdr.car
    assert_equal 3, list.first.cdr.cdr.car
  end
  #
  # def test_parsing_something_more_complex
  #   assert_equal [[:+, [:*, 2, 2], [:/, 8, 2]]], @parser.parse("(+ (* 2 2) (/ 8 2))")
  # end
  #
  # def test_parsing_multiple_expressions
  #   assert_equal [[:define, :foo, 42], [:+, :foo, 3]], @parser.parse("(define foo 42)(+ foo 3)")
  # end
  #
  def test_parsing_quote
    # assert_equal [[:quote, :hello]], @parser.parse("(quote hello)")
    list = @parser.parse("(quote hello)")
    # puts list
    assert_equal ::Yambda::Cons, list.first.class
    # We want to look-ahead one token in this case; if the token directly _after_ a '('
    #   is a `quote` keyword, we don't want to nest the quoted thing in an extra cons cell.
    assert_equal :quote, list.first.car

  end

  def test_parsing_single_quoted_string
    # assert_equal [[:quote, :hello]], @parser.parse("'hello")
    list = @parser.parse("'hello")
    assert_equal :quote, list.first.car
    assert_equal :hello, list.first.cdr.car
    assert_nil list.first.cdr.cdr
  end

  # # note, eval doesn't support lists yet, but we can parse them
  # def test_parsing_a_list
  #   assert_equal [[:list, 1, 2, 3]], @parser.parse("(list 1 2 3)")
  # end
  #
  # we'd like to have quoted lists, too
  def test_parsing_quoted_list
    # assert_equal [[:list, 1, 2, 3]], @parser.parse("'(1 2 3)")
    list = @parser.parse("'(1 2 3)")
    assert_equal :quote, list.first.car
    assert_equal ::Yambda::Cons, list.first.cdr.car.class
  end

  def test_parsing_a_simple_lambda_expression
    list = @parser.parse("(lambda (x) x)")
    assert_equal :lambda, list.first.car
    assert_equal ::Yambda::Cons, list.first.cdr.car.class # the first thing after the lambda should be the list of args
    assert_equal :x, list.first.cdr.car.car
    assert_equal :x, list.first.cdr.cdr.car # x is the whole body of this expression; expect to see that here.
  end
end