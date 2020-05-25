class Dock
  attr_reader :name,
              :max_rental_time,
              :rental_log,
              :revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    amount = 0
    if boat.hours_rented <= @max_rental_time
      amount = boat.price_per_hour * boat.hours_rented
    else
      amount = boat.price_per_hour * @max_rental_time
    end
    @revenue += amount
    charge_info = {}
    charge_info[:card_number] = @rental_log[boat].credit_card_number
    charge_info[:amount] = amount
    charge_info
  end

  def log_hour
    @rental_log.each do |boat, renter|
      boat.add_hour
    end
  end

  def return(boat)
    charge(boat)
    @rental_log.delete(boat)
  end
end
