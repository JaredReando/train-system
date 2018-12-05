require 'spec_helper'

describe(City) do
  describe("#all") do
    it("starts off with no lists") do
      expect(City.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("returns its name") do
      city = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      expect(city.name()).to(eq("Portland"))
    end
  end

  describe("#id") do
    it("sets its id when saved") do
      city = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      city.save()
      expect(city.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#save") do
    it("saves city to the database") do
      city = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      city.save()
      expect(City.all()).to(eq([city]))
    end
  end

  describe("#update") do
    it("updates city to the database") do
      city = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      city.save()
      city.update({:name => "Vancouver", :state => "Washington"})
      expect(city.name()).to(eq("Vancouver"))
      expect(city.state()).to(eq("Washington"))
    end
  end

  describe('#delete')do
    it("deletes a city from the database")do
    city = City.new({:name => "Portland", :state => "Oregon", :id => nil})
    city.save()
    city.delete
    expect(City.all).to(eq([]))
  end
  end

  describe(".all_by_state") do
    it("sorts based off of state") do
      city1 = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      city1.save()
      city2 = City.new({:name => "San Francisco", :state => "California", :id => nil})
      city2.save()
      expect(City.all_by_state("Oregon")).to(eq([city1]))
    end
  end

  describe("#==") do
    it("is the same if the id and name match") do
      city1 = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      city2 = City.new({:name => "Portland", :state => "Oregon", :id => nil})
      expect(city1).to(eq(city2))
    end
  end

end
