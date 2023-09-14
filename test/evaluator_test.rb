# frozen_string_literal: true

require "test_helper"

class EvaluatorTest < Minitest::Test
  def setup
    @parser = ::Yambda::Parser.new
    env = ::Yambda::Environment.new
    env.update({:foo => 42, :+ => ->(x, y){ x + y },
                :* => ->(x, y){ x * y },
                :cons => ->(x, y){ ::Yambda::Cons.new(x, y) },
                :eq => ->(x, y){ x == y }
               })
    @evaluator = ::Yambda::Evaluator.new(env)
  end

  def test_evaluating_a_parsed_expression
    # binding.pry
    exp = @parser.parse("(+ 2 3)")
    # parse returns a list of expressions; since we're testing eval, we'll just eval the first (& only) expression
    result = @evaluator.eval(exp.first)
    assert_equal 5, result
  end

  def test_eval_all_only_returns_last_result
    exps = @parser.parse("(+ 2 3)(+ 4 4)")
    result = @evaluator.eval_all(exps)
    assert_equal 8, result
  end

  def test_eval_when_it_needs_an_env_lookup
    exps = @parser.parse("(define foo 3)(+ foo 4)")
    result = @evaluator.eval_all(exps)
    assert_equal 7, result
  end

  def test_eval_with_a_quoted_list_returns_the_string_representation
    exps = @parser.parse("'(1 2 3)")
    result = @evaluator.eval_all(exps)
    assert_equal "'(1 2 3)", result
  end

  # def test_eval_with_a_list
  #   exps = @parser.parse("(list 1 2 3)")
  #   result = @evaluator.eval_all(exps)
  #   assert_equal "'(1 2 3)", result
  # end

  def test_eval_but_its_a_lambda
    exps = @parser.parse("((lambda (x y) (+ x y)) 1 2)")
    result = @evaluator.eval_all(exps)
    assert_equal 3, result
  end

  def test_with_a_lambda_that_is_saved_in_the_env
    exps = @parser.parse("(define square (lambda (x) (* x x)))(square 4)")
    result = @evaluator.eval_all(exps)
    assert_equal 16, result
  end

  def test_eval_cons_atom_with_empty_list
    exps = @parser.parse("(cons 1 '())")
    result = @evaluator.eval_all(exps)
    assert_equal "'(1)", result.to_s
  end

  def test_eval_if_expression
    exps = @parser.parse("(if (eq 3 3) 'fizz 'buzz)")
    result = @evaluator.eval_all(exps)
    assert_equal "'fizz", result
  end
end