# frozen_string_literal: true

require "test_helper"

class ConsTest < Minitest::Test
  def setup
    @single_element = ::Yambda::Cons.new(1, nil)
    @two_element = ::Yambda::Cons.new(1, ::Yambda::Cons.new(2, nil))
    @three_element = ::Yambda::Cons.new(1, ::Yambda::Cons.new(2, ::Yambda::Cons.new(3, ::Yambda::EmptyList.new())))
  end

  def test_list?
    assert @three_element.list?
  end

  def test_empty_list_is_a_list
    assert ::Yambda::EmptyList.new.list?
  end

  def test_list_with_a_pair
    refute ::Yambda::Cons.new(1, 2).list?
  end

  def test_cons_two_atoms_is_a_pair_but_not_a_list
    pair = ::Yambda::Cons.new(1, 2)
    assert pair.pair?
    refute pair.list?
  end

  def test_cons_atom_with_nil_is_a_list
    assert ::Yambda::Cons.new(1, nil).list?
  end

  def test_cons_atom_with_empty_list_literal_is_a_list
    assert ::Yambda::Cons.new(1, "'()").list?
  end

  def test_cons_atom_with_empty_list_object_is_a_list
    assert ::Yambda::Cons.new(1, ::Yambda::EmptyList.new).list?
  end

  def test_a_list_is_still_a_pair
    assert @three_element.pair?
  end

  def test_empty_list_is_not_a_pair_though
    refute ::Yambda::EmptyList.new.pair?
  end

  def test_a_single_element_list_is_a_list_and_a_pair
    assert @single_element.list?
    assert @single_element.pair?
  end

  def test_empty_list_to_a
    assert_equal [], ::Yambda::EmptyList.new.to_a
  end

  def test_single_element_list_to_a
    assert_equal [1], @single_element.to_a
  end

  def test_pair_to_a
    assert_equal [1, 2], ::Yambda::Cons.new(1, 2).to_a
  end

  def test_two_element_to_a
    assert_equal [1, 2], @two_element.to_a
  end

  def test_three_element_to_a
    assert_equal [1, 2, 3], @three_element.to_a
  end

  def test_nested_list_to_a
    assert_equal [[1], [1, 2], [1, 2, 3], 4], ::Yambda::Cons.new(@single_element, ::Yambda::Cons.new(@two_element, ::Yambda::Cons.new(@three_element, ::Yambda::Cons.new(4, nil)))).to_a
  end

  def test_empty_list_to_s
    assert_equal "'()", ::Yambda::EmptyList.new.to_s
  end

  def test_single_element_list_to_s
    assert_equal "'(1)", @single_element.to_s
  end

  def test_two_element_list_to_s
    assert_equal "'(1 2)", @two_element.to_s
  end

  def test_three_element_list
    assert_equal "'(1 2 3)", @three_element.to_s
  end

  def test_nested_lists_to_s
    list = ::Yambda::Cons.new(@three_element, ::Yambda::Cons.new(4, nil))
    assert_equal "'((1 2 3) 4)", list.to_s
  end

  def test_different_nested_lists
    list = ::Yambda::Cons.new(0, ::Yambda::Cons.new(@three_element, nil))
    assert_equal "'(0 (1 2 3))", list.to_s
  end

  def test_more_different_nested_lists
    list = ::Yambda::Cons.new(0, ::Yambda::Cons.new(@three_element, ::Yambda::Cons.new(4, nil)))
    assert_equal "'(0 (1 2 3) 4)", list.to_s
  end

end