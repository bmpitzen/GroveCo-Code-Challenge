require 'minitest/autorun'
require_relative 'find_store.rb'

class FindStoreTest < Minitest::Test
  def test_coordinates_from_zip
    assert_equal [34.5521821, -77.53901270000001], zip_to_coordinates(28445)
  end

  def test_coordinates_from_address
    assert_equal [37.3318737, -122.0302472], address_to_coordinates('1 Infinite Loop, Cupertino, CA')
  end

  def test_haversine
    assert_equal 2473.4050568998377, haversine([34.5521821, -77.53901270000001], [37.3318737, -122.0302472])
  end

  # def test_parse_args
  #   assert_equal @address == '1 Infinite Loop, Cupertino, CA', parse_args
  # end

  # def test_address_or_zip
  #   assert_equal [34.5521821, -77.53901270000001], parse_args
  #   address_or_zip
  # end
  # def test_colsest_store
  #   assert_equal '', closest_store([37.3318737, -122.0302472])
  # end
end
