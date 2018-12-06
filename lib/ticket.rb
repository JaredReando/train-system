class Ticket

  attr_reader(:rider_id, :train_id, :start_city_id, :end_city_id, :id)

  def initialize(attributes)
    @rider_id = attributes[:rider_id]
    @train_id = attributes[:train_id]
    @start_city_id = attributes[:start_city_id]
    @end_city_id = attributes[:end_city_id]
    @id = attributes[:id]
  end

  def self.all_basic(tickets)
    output_tickets = []
    tickets.each() do |ticket|
      rider_id = ticket["rider_id"].to_i
      train_id = ticket["train_id"].to_i
      start_city_id = ticket["start_city_id"].to_i
      end_city_id = ticket["end_city_id"].to_i
      id = ticket["id"].to_i
      output_tickets.push(Ticket.new({:rider_id => rider_id, :train_id => train_id, :start_city_id => start_city_id, :end_city_id => end_city_id, :id => id}))
    end
    output_tickets
  end

  def self.all
    returned_tickets = DB.exec("SELECT * FROM tickets;")
    Ticket.all_basic(returned_tickets)
  end

  def save
    result = DB.exec("INSERT INTO tickets (rider_id, train_id, start_city_id, end_city_id) VALUES (#{@rider_id}, #{@train_id}, #{@start_city_id}, #{@end_city_id} ) RETURNING id;")
    @id = result.first["id"].to_i
  end

  def ==(other_instance)
    @rider_id == other_instance.rider_id && @train_id == other_instance.train_id && @start_city_id == other_instance.start_city_id && @end_city_id == other_instance.end_city_id
  end

  def get_important_details
    train = Train.find_by_id(@train_id)
    start_city = City.find_by_id(@start_city_id)
    end_city = City.find_by_id(@end_city_id)
    rider = Rider.find_by_id(@rider_id)
    train_details = train.name
    start_details = "#{start_city.name}, #{start_city.state}"
    end_details = "#{end_city.name}, #{end_city.state}"
    rider_details = rider.name
    return {:train_details => train_details, :start_city_details => start_details, :end_city_details => end_details, :rider_details => rider_details}
  end

  def self.find_by_id(id)
    returned_ticket = DB.exec("SELECT * FROM tickets WHERE id = #{id}")
    Ticket.all_basic(returned_ticket)[0]
  end
end
