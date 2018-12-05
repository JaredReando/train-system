require 'spec_helper'

describe(Stop) do
  describe("#all") do
    it("starts off with no stops") do
      expect(Stop.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("returns its name") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      expect(stop.train_id()).to(eq(1))
    end
  end

  describe("#id") do
    it("sets its id when saved") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      stop.save()
      expect(stop.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#save") do
    it("saves stop to the database") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      stop.save()
      expect(Stop.all()).to(eq([stop]))
    end
  end

  describe("#update") do
    it("updates stop to the database") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      stop.save()
      stop.update({:train_id => 5, :city_id => 7, :time => "00:00"})
      expect(stop.train_id()).to(eq(5))
      expect(stop.city_id()).to(eq(7))
    end
  end

  describe('#delete')do
    it("deletes a stop from the database")do
    stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
    stop.save()
    stop.delete
    expect(Stop.all).to(eq([]))
    end
  end

  describe(".all_by_city_id") do
    it("sorts based off of city") do
      stop1 = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      stop1.save()
      stop2 = Stop.new({:train_id => 2, :city_id => 1, :id => nil, :time => "00:00"})
      stop2.save()
      expect(Stop.all_by_city_id(2)).to(eq([stop1]))
    end
  end

  describe(".all_by_train_id") do
    it("sorts based off of train") do
      stop1 = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      stop1.save()
      stop2 = Stop.new({:train_id => 2, :city_id => 1, :id => nil, :time => "00:00"})
      stop2.save()
      expect(Stop.all_by_train_id(2)).to(eq([stop2]))
    end
  end

  describe("#==") do
    it("is the same if the id and name match") do
      stop1 = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      stop2 = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      expect(stop1).to(eq(stop2))
    end
  end

  describe(".find_by_id") do
    it("will find the stop with a given id") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil, :time => "00:00"})
      stop.save
      expect(Stop.find_by_id(stop.id)).to(eq(stop))
    end
  end

  describe(".get_cities_by_train") do
    it("gets all cities that a train stops in") do
      city1 = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      city1.save
      city2 = City.new({:name => "San Francisco", :state => "California", :id => nil})
      city2.save
      train1 = Train.new({:name => "Red Line", :direction => "West", :id => nil})
      train1.save()
      train2 = Train.new({:name => "Green Line", :direction => "East", :id => nil})
      train2.save()
      stop1 = Stop.new({:train_id => train1.id, :city_id => city1.id, :id => nil, :time => "00:00"})
      stop2 = Stop.new({:train_id => train1.id, :city_id => city2.id, :id => nil, :time => "00:00"})
      stop3 = Stop.new({:train_id => train2.id, :city_id => city1.id, :id => nil, :time => "00:00"})
      stop1.save
      stop2.save
      stop3.save
      expect(Stop.get_cities_by_train(train1.id)).to(eq([city1, city2]))
      expect(Stop.get_cities_by_train(train2.id)).to(eq([city1]))
    end
  end

  describe(".get_trains_by_city") do
    it("gets all cities that a train stops in") do
      city1 = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      city1.save
      city2 = City.new({:name => "San Francisco", :state => "California", :id => nil})
      city2.save
      train1 = Train.new({:name => "Red Line", :direction => "West", :id => nil})
      train1.save()
      train2 = Train.new({:name => "Green Line", :direction => "East", :id => nil})
      train2.save()
      stop1 = Stop.new({:train_id => train1.id, :city_id => city1.id, :id => nil, :time => "00:00"})
      stop2 = Stop.new({:train_id => train1.id, :city_id => city2.id, :id => nil, :time => "00:00"})
      stop3 = Stop.new({:train_id => train2.id, :city_id => city1.id, :id => nil, :time => "00:00"})
      stop1.save
      stop2.save
      stop3.save
      expect(Stop.get_trains_by_city(city1.id)).to(eq([train1, train2]))
      expect(Stop.get_trains_by_city(city2.id)).to(eq([train1]))
    end
  end

end
