# frozen_string_literal: true

require "test_helper"

class EnvironmentTest < Minitest::Test
  def setup
    @env = ::Yambda::Environment.new
  end

  def test_environment
    @env.update({:foo => "bar"})
    assert_equal "bar", @env.lookup(:foo)
  end

  def test_environment_when_key_not_found
    assert_raises StandardError do
      @env.lookup(:coldfusion)
    end
  end
end