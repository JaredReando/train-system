require 'spec_helper'

describe(Stop) do
  describe("#all") do
    it("starts off with no stops") do
      expect(Stop.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("returns its name") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      expect(stop.train_id()).to(eq(1))
    end
  end

  describe("#id") do
    it("sets its id when saved") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      stop.save()
      expect(stop.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#save") do
    it("saves stop to the database") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      stop.save()
      expect(Stop.all()).to(eq([stop]))
    end
  end

  describe("#update") do
    it("updates stop to the database") do
      stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      stop.save()
      stop.update({:train_id => 5, :city_id => 7})
      expect(stop.train_id()).to(eq(5))
      expect(stop.city_id()).to(eq(7))
    end
  end

  describe('#delete')do
    it("deletes a stop from the database")do
    stop = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
    stop.save()
    stop.delete
    expect(Stop.all).to(eq([]))
    end
  end

  describe(".all_by_city_id") do
    it("sorts based off of city") do
      stop1 = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      stop1.save()
      stop2 = Stop.new({:train_id => 2, :city_id => 1, :id => nil})
      stop2.save()
      expect(Stop.all_by_city_id(2)).to(eq([stop1]))
    end
  end

  describe(".all_by_train_id") do
    it("sorts based off of train") do
      stop1 = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      stop1.save()
      stop2 = Stop.new({:train_id => 2, :city_id => 1, :id => nil})
      stop2.save()
      expect(Stop.all_by_train_id(2)).to(eq([stop2]))
    end
  end

  describe("#==") do
    it("is the same if the id and name match") do
      stop1 = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      stop2 = Stop.new({:train_id => 1, :city_id => 2, :id => nil})
      expect(stop1).to(eq(stop2))
    end
  end

end
