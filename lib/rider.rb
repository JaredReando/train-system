class Rider

  attr_reader(:name, :id)

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all_basic(riders)
    output_riders = []
    riders.each() do |stop|
      id = stop["id"].to_i
      name = stop["name"]
      output_riders.push(Rider.new({:id => id, :name => name}))
    end
    output_riders
  end

  def self.all
    returned_riders = DB.exec("SELECT * FROM riders;")
    Rider.all_basic(returned_riders)
  end

  def save
    result = DB.exec("INSERT INTO riders (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first["id"].to_i
  end

  def ==(other_instance)
    @name == other_instance.name
  end

  def self.find_by_id(id)
    returned_rider = DB.exec("SELECT * FROM riders WHERE id = #{id}")
    Rider.all_basic(returned_rider)[0]
  end

  def self.get_customer(name)
    returned_rider = DB.exec("SELECT * FROM riders WHERE name = '#{name}'")
    if(!(returned_rider.any?))
      rider = Rider.new({:name => name})
      rider.save
      return rider
    else
      return (Rider.all_basic(returned_rider))[0]
    end
  end
end
