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

get("/rider") do

(erb :index)
end

get("/operator") do
  @cities = City.all
  # @stops = Stop.all
  @trains = Train.all
(erb :operator)
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
  # @stops = Stop.all
  @trains = Stop.get_trains_by_city(city_id)
  @city = City.find_by_id(city_id)
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


# post("/") do
#   if (params[:list_entry] == "")
#     redirect "/"
#   else
#     list_entry = params[:list_entry].capitalize
#     new_list = List.new(:name => list_entry)
#     new_list.save
#     @lists = List.all
#     redirect "/"
#   end
# end
#
# get("/tasks/:id") do
# @list_id = params[:id].to_i
# @list = List.find_list(@list_id)
# @tasks = @list.tasks
#
# (erb :tasks)
# end
#
# patch("/tasks/:id") do
#   name = params.fetch("name")
#   @list = List.find_list(params.fetch("id").to_i())
#   @list.update({:name => name})
#   @tasks = @list.tasks
#   erb(:tasks)
# end
#
# delete("/tasks/:id") do
#   @list = List.find_list(params.fetch("id").to_i())
#   @list.delete()
#   redirect "/"
# end
#
# # post("/tasks/:id") do
# # list_id = params[:id]
# # task_description = params[:task_entry]
# #   if (task_description == "")
# #     redirect "/tasks/#{list_id}"
# #   else
# #     task = Task.new(:description => task_description, :list_id => list_id)
# #     task.save
# #     redirect "/tasks/#{list_id}"
# #   end
# # end
#
# post("/add_task") do
#   list_id = params[:list_entry]
#   task_description = params[:description]
#   task = Task.new(:description => task_description, :list_id => list_id)
#   task.save
#   redirect "/"
# end
