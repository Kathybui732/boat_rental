require "minitest/autorun"
require "minitest/pride"
require "./lib/dock"
require "./lib/renter"
require "./lib/boat"

class DockTest < MiniTest::Test

	def setup
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
    @canoe = Boat.new(:canoe, 25)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
	end

  def test_it_exists
    assert_instance_of Dock, @dock
  end

  def test_it_has_attributes
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
  end

  def test_rented_boats_added_to_rental_log
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    @dock.rental_log
    expected = {
      @kayak_1 => @patrick,
      @kayak_2 => @patrick,
      @sup_1 => @eugene
    }
    assert_equal expected, @dock.rental_log
  end

  def test_it_can_charge
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    @kayak_1.add_hour
    @kayak_1.add_hour
    expected = {
      :card_number => "4242424242424242",
      :amount => 40
    }
    assert_equal expected, @dock.charge(@kayak_1)
  end

  def test_it_has_max_charge
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    expected = {
      :card_number => "1313131313131313",
      :amount => 45
    }
    assert_equal expected, @dock.charge(@sup_1)
  end

  def test_return_boat
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    @dock.revenue
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)
    assert_equal 105, @dock.revenue
  end

  def test_it_can_log_hours
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    assert_equal 0, @dock.revenue
  end

  def test_total_revenue
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    @dock.revenue
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)
    @dock.rent(@sup_1, @eugene)
    @dock.rent(@sup_2, @eugene)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.return(@sup_1)
    @dock.return(@sup_2)
    assert_equal 195, @dock.revenue
  end
end
