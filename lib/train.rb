require'pry'

class Train
  attr_reader(:name, :direction, :id)

  def initialize(attributes)
    @name = attributes[:name]
    @direction = attributes[:direction]
    @id = attributes[:id]
  end

  def self.all_basic(trains)
    output_trains = []
    trains.each() do |train|
      name = train["name"]
      direction = train["direction"]
      id = train["id"].to_i
      output_trains.push(Train.new({:name => name, :direction => direction, :id => id}))
    end
    output_trains
  end

  def self.all
    returned_trains = DB.exec("SELECT * FROM trains;")
    Train.all_basic(returned_trains)
  end

  def save
    result = DB.exec("INSERT INTO trains (name, direction) VALUES ('#{@name}', '#{@direction}') RETURNING id;")
    @id = result.first["id"].to_i
  end

  def update(params)
    @name = params[:name]
    @direction = params[:direction]
    DB.exec("UPDATE trains SET name = '#{@name}', direction = '#{@direction}' WHERE id = #{@id}")
  end

  def delete
    DB.exec("DELETE FROM trains WHERE id = #{@id}")
    DB.exec("DELETE FROM stops WHERE trains_id = #{@id}")
  end

  def self.all_by_direction(direction)
    returned_trains = DB.exec("SELECT * FROM trains WHERE direction = '#{direction}'")
    Train.all_basic(returned_trains)
  end

  def ==(other_instance)
    @name == other_instance.name && @direction == other_instance.direction
  end

  def self.find_by_id(id)
    returned_train = DB.exec("SELECT * FROM trains WHERE id = #{id}")
    Train.all_basic(returned_train)[0]
  end

end
