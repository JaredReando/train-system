require'pry'

class City
  attr_reader(:name, :state, :id)

  def initialize(attributes)
    @name = attributes[:name]
    @state = attributes[:state]
    @id = attributes[:id]
  end

  def self.all_basic(cities)
    output_cities = []
    cities.each() do |city|
      name = city["name"]
      state = city["state"]
      id = city["id"].to_i
      output_cities.push(City.new({:name => name, :state => state, :id => id}))
    end
    output_cities
  end

  def self.all
    returned_cities = DB.exec("SELECT * FROM cities;")
    City.all_basic(returned_cities)
  end

  def save
    result = DB.exec("INSERT INTO cities (name, state) VALUES ('#{@name}', '#{@state}') RETURNING id;")
    @id = result.first["id"].to_i
  end

  def update(params)
    @name = params[:name]
    @state = params[:state]
    DB.exec("UPDATE cities SET name = '#{@name}', state = '#{@state}' WHERE id = #{@id}")
  end

  def delete
    DB.exec("DELETE FROM cities WHERE id = #{@id}")
  end

  def self.all_by_state(state)
    returned_cities = DB.exec("SELECT * FROM cities WHERE state = '#{state}'")
    City.all_basic(returned_cities)
  end

  def ==(other_instance)
    @name == other_instance.name && @state == other_instance.state
  end

end
