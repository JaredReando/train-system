require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/train")
require("./lib/city")
require("./lib/stop")
require("pg")

DB = PG.connect({:dbname => "train_system"})

get("/") do
  (erb :index)
end

get("/operator") do
  @cities = City.all
  @trains = Train.all
(erb :operator)
end

get("/rider") do
  @cities = City.all
  @trains = Train.all
(erb :rider)
end

get("/train_info/:id") do
  train_id = params[:id].to_i
  @train = Train.find_by_id(train_id)
  @cities = City.all
  @train_stops = Stop.get_important_train_info(train_id)
  (erb :train_info)
end

get("/city_info/:id") do
  city_id = params[:id].to_i
  @trains = Stop.get_trains_by_city(city_id)
  @city = City.find_by_id(city_id)
  @local_trains = Stop.get_important_city_info(city_id)
  (erb :city_info)
end

post("/add_train") do
  train_name = params.fetch("train_name")
  train_direction = params.fetch("train_direction")
  train = Train.new({:name => train_name, :direction => train_direction})
  train.save()
  redirect ("/operator")
end

post("/add_city") do
  city_name = params.fetch("city_name")
  state = params.fetch("state")
  city = City.new({:name => city_name, :state => state})
  city.save()
  redirect ("/operator")
end

get("/cities/:id") do
  city_id = params[:id].to_i
  @trains = Stop.get_trains_by_city(city_id)
  @city = City.find_by_id(city_id)
  @local_trains = Stop.get_important_city_info(city_id)
  (erb :city_view)
end

get("/trains/:id")do
  train_id = params[:id].to_i
  @train = Train.find_by_id(train_id)
  @cities = City.all
  @train_stops = Stop.get_important_train_info(train_id)
  (erb :train_view)
end

post("/add_stop/:id") do
  train_id = params[:id].to_i
  city_id = params[:city].to_i
  time = params[:time]
  stop = Stop.new({:train_id => train_id, :city_id => city_id, :time => time})
  stop.save
  redirect ("/trains/#{train_id}")
end

delete("/cities/:id") do
  city_id = params[:id].to_i
  city = City.find_by_id(city_id)
  city.delete
  redirect("/operator")
end

delete("/trains/:id") do
  train_id = params[:id].to_i
  train = Train.find_by_id(train_id)
  train.delete
  redirect("/operator")
end

delete("/stops/:id") do
  stop_id = params[:id].to_i
  train_id = params[:train_id].to_i
  stop = Stop.find_by_id(stop_id)
  stop.delete
  redirect("/trains/#{train_id}")
end

patch("/trains/:id")do
  train_id = params[:id].to_i
  name = params[:train_name]
  direction = params[:train_direction]
  train = Train.find_by_id(train_id)
  train.update({:name => name, :direction => direction})
  redirect ("/trains/#{train_id}")
end

patch("/cities/:id")do
  city_id = params[:id].to_i
  name = params[:city_name]
  state = params[:state]
  city = City.find_by_id(city_id)
  city.update({:name => name, :state => state})
  redirect ("/cities/#{city_id}")
end
