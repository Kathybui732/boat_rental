require "minitest/autorun"
require "minitest/pride"
require "./lib/boat"

class BoatTest < MiniTest::Test

	def setup
    @kayak = Boat.new(:kayak, 20)
	end

  def test_it_exists
    assert_instance_of Boat, @kayak
  end

  def test_it_has_attributes
    assert_equal :kayak, @kayak.type
    assert_equal 20, @kayak.price_per_hour
  end

  def test_hours_rented_starts_at_0
    assert_equal 0, @kayak.hours_rented
  end

  def test_it_can_add_hours
    @kayak.add_hour
    @kayak.add_hour
    @kayak.add_hour
    assert_equal 3, @kayak.hours_rented
  end
end
