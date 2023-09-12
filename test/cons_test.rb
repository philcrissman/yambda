# frozen_string_literal: true

require "test_helper"

class ConsTest < Minitest::Test
  def setup
    @cons = ::Yambda::Cons.new(1, ::Yambda::Cons.new(2, ::Yambda::Cons.new(3)))
  end

  def test_to_s
    assert_equal "'(1 2 3)", @cons.to_s
  end
end