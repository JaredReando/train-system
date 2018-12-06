require 'spec_helper'

describe(Ticket) do
  describe("#all") do
    it("starts off with no tickets") do
      expect(Ticket.all()).to(eq([]))
    end
  end

  describe("#id") do
    it("sets its id when saved") do
      ticket = Ticket.new({:rider_id => 1, :train_id => 1, :start_city_id => 1,:end_city_id => 2})
      ticket.save()
      expect(ticket.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#save") do
    it("saves ticket to the database") do
      ticket = Ticket.new({:rider_id => 1, :train_id => 1, :start_city_id => 1,:end_city_id => 2})
      ticket.save()
      expect(Ticket.all()).to(eq([ticket]))
    end
  end

  describe("#==") do
    it("is the same if the id and name match") do
      ticket1 = Ticket.new({:rider_id => 1, :train_id => 1, :start_city_id => 1,:end_city_id => 2})
      ticket2 = Ticket.new({:rider_id => 1, :train_id => 1, :start_city_id => 1,:end_city_id => 2})
      expect(ticket1).to(eq(ticket2))
    end
  end

  describe(".find_by_id") do
    it("will find the ticket with a given id") do
      ticket = Ticket.new({:rider_id => 1, :train_id => 1, :start_city_id => 1,:end_city_id => 2})
      ticket.save
      expect(Ticket.find_by_id(ticket.id)).to(eq(ticket))
    end
  end

  describe("#get_important_details") do
    it("will provide a hash with all the details needed to display a ticket") do
      rider = Rider.new({:name => "Paige"})
      rider.save
      train = Train.new({:name => "Red Line", :direction => "West"})
      train.save
      city1 = City.new({:name => "Portland", :state => "Oregon"})
      city1.save()
      city2 = City.new({:name => "San Francisco", :state => "California"})
      city2.save()
      ticket = Ticket.new({:rider_id => rider.id, :train_id => train.id, :start_city_id => city1.id, :end_city_id => city2.id})
      ticket.save
      expect(ticket.get_important_details).to(eq({:train_details => "Red Line", :start_city_details => "Portland, Oregon", :end_city_details => "San Francisco, California", :rider_details => "Paige"}))
    end
  end
end
