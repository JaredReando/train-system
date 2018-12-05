class Stop

  attr_reader(:train_id, :city_id, :id)

  def initialize(attributes)
    @train_id = attributes[:train_id]
    @city_id = attributes[:city_id]
    @id = attributes[:id]
    @time = attributes[:time]
  end

  def self.all_basic(stops)
    output_stops = []
    stops.each() do |stop|
      train_id = stop["trains_id"].to_i
      city_id = stop["cities_id"].to_i
      id = stop["id"].to_i
      time = stop["time"]
      output_stops.push(Stop.new({:train_id => train_id, :city_id => city_id, :id => id, :time => time}))
    end
    output_stops
  end

  def self.all
    returned_stops = DB.exec("SELECT * FROM stops;")
    Stop.all_basic(returned_stops)
  end

  def save
    result = DB.exec("INSERT INTO stops (trains_id, cities_id, time) VALUES (#{@train_id}, #{@city_id}, '#{@time}') RETURNING id;")
    @id = result.first["id"].to_i
  end

  def update(params)
    @train_id = params[:train_id].to_i
    @city_id = params[:city_id].to_i

    DB.exec("UPDATE stops SET trains_id = #{@train_id}, cities_id = #{@city_id} WHERE id = #{@id}")
  end

  def delete
    DB.exec("DELETE FROM stops WHERE id = #{@id}")
  end

  def self.all_by_city_id(city_id)
    returned_stops = DB.exec("SELECT * FROM stops WHERE cities_id = #{city_id}")
    Stop.all_basic(returned_stops)
  end

  def self.all_by_train_id(train_id)
    returned_stops = DB.exec("SELECT * FROM stops WHERE trains_id = #{train_id}")
    Stop.all_basic(returned_stops)
  end

  def ==(other_instance)
    @train_id == other_instance.train_id && @city_id == other_instance.city_id
  end

  def self.find_by_id(id)
    returned_stop = DB.exec("SELECT * FROM stops WHERE id = #{id}")
    Stop.all_basic(returned_stop)[0]
  end

  def self.get_cities_by_train(train_id)
    stops = DB.exec("SELECT * FROM stops WHERE trains_id = #{train_id} ORDER BY time")
    cities = []
    stops.each do |stop|
      cities.push(City.find_by_id(stop.fetch("cities_id").to_i))
    end
    cities
  end

  def self.get_trains_by_city(city_id)
    stops = DB.exec("SELECT * FROM stops WHERE cities_id = #{city_id} ORDER BY time")
    trains = []
    stops.each do |stop|
      trains.push(Train.find_by_id(stop.fetch("trains_id").to_i))
    end
    trains
  end

  def self.get_important_train_info(train_id)
    important_stops = DB.exec("SELECT time, cities.name AS city_name, state, trains.name AS train_name, direction FROM trains INNER JOIN stops s ON s.trains_id=trains.id INNER JOIN cities ON s.cities_id=cities.id WHERE trains.id = #{train_id} ORDER BY time;")
  end

  def self.get_important_city_info(city_id)
    important_stops = DB.exec("SELECT time, cities.name AS city_name, state, trains.name AS train_name, direction FROM cities INNER JOIN stops s ON s.cities_id=cities.id INNER JOIN trains ON s.trains_id=trains.id WHERE cities.id = #{city_id} ORDER BY time;")
  end
end
# SELECT time, cities.name AS city_name, state, trains.name AS train_name, direction FROM trains INNER JOIN stops ON stops.trains_id=trains.id INNER JOIN cities ON stops.cities_id=cities.id
# ;
