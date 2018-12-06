require 'spec_helper'

describe(Rider) do
  describe("#all") do
    it("starts off with no riders") do
      expect(Rider.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("returns its name") do
      rider = Rider.new({:name => "Paige"})
      expect(rider.name()).to(eq("Paige"))
    end
  end

  describe("#id") do
    it("sets its id when saved") do
      rider = Rider.new({:name => "Paige"})
      rider.save()
      expect(rider.id()).to(be_an_instance_of(Integer))
    end
  end

  describe("#save") do
    it("saves rider to the database") do
      rider = Rider.new({:name => "Paige"})
      rider.save()
      expect(Rider.all()).to(eq([rider]))
    end
  end

  describe("#==") do
    it("is the same if the id and name match") do
      rider1 = Rider.new({:name => "Paige"})
      rider2 = Rider.new({:name => "Paige"})
      expect(rider1).to(eq(rider2))
    end
  end

  describe(".find_by_id") do
    it("will find the rider with a given id") do
      rider = Rider.new({:name => "Paige"})
      rider.save
      expect(Rider.find_by_id(rider.id)).to(eq(rider))
    end
  end
end
