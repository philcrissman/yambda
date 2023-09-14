# frozen_string_literal: true

require "test_helper"

class RuntimeTest < Minitest::Test
  def setup
    @runtime = ::Yambda::Runtime.new
  end

  def test_cons
    result = @runtime.run("(cons 1 2)")
    assert_equal "'(1 2)", result
  end

  def test_cons_with_emtpy_list
    result = @runtime.run("(cons 1 '())")
    assert_equal "'(1)", result
  end

  def test_car
    result = @runtime.run("(car (cons 1 2))")
    assert_equal "1", result
  end

  # def test_cdr
  #   result = @runtime.run("(cdr (cons 1 (cons 2 '())))")
  #   assert_equal "'(2)", result
  # end
end