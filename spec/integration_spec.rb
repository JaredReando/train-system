require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('Add a train in the operator view', {:type => :feature}) do
  it('allows a user to add a train to the system') do
    visit('/operator')
    fill_in('train_name', :with =>'Yellow Line')
    fill_in('train_direction', :with =>'East-West')
    click_button('Add a train')
    expect(page).to have_content('Yellow Line')
  end
end

describe('Add a city in the operator view', {:type => :feature}) do
  it('allows a user to add a city to the system') do
    visit('/operator')
    fill_in('city_name', :with =>'Portland')
    fill_in('state', :with =>'Oregon')
    click_button('Add a city')
    expect(page).to have_content('Portland')
  end
end

describe('Update city information', {:type => :feature}) do
  it('allows a user to update city details in the system') do
    city = City.new({name: 'Portland', state: 'OR'})
    city.save
    visit("/cities/#{city.id}")
    fill_in('city_name', :with =>'Seattle')
    fill_in('state', :with =>'WA')
    click_button('Edit')
    expect(page).to have_content('Seattle')
    expect(page).to have_content('WA')
  end
end

describe('Update train information', {:type => :feature}) do
  it('allows a user to train details in the system') do
    train = Train.new(name: 'Yellow Line', direction: 'East-West')
    train.save
    visit("/trains/#{train.id}")
    fill_in('train_name', :with =>'Thomas')
    fill_in('train_direction', :with =>'Diagonal')
    click_button('Edit')
    expect(page).to have_content('Thomas')
    expect(page).to have_content('Diagonal')
  end
end

describe('Add a train stop', {:type => :feature}) do
  it('allows an operator to add a train stop') do
    train = Train.new(name: 'Yellow Line', direction: 'East-West')
    train.save
    city = City.new({name: 'Portland', state: 'OR'})
    city.save
    visit("/trains/#{train.id}")
    fill_in('time', :with =>'08:00')
    select('Portland, OR', :from => 'city')
    click_button('Add a stop')
    expect(page).to have_content('08:00')
    expect(page).to have_content('Portland')
  end
end


describe('Delete a train stop', {:type => :feature}) do
  it('allows an operator to delete a train stop') do
    train = Train.new(name: 'Yellow Line', direction: 'East-West')
    train.save
    city = City.new({name: 'Portland', state: 'OR'})
    city.save
    stop1 = Stop.new({train_id: train.id, city_id: city.id, time: '23:00'})
    stop1.save
    stop2 = Stop.new({train_id: train.id, city_id: city.id, time: '08:00'})
    stop2.save
    visit("/trains/#{train.id}")
    click_button("#{stop2.id}")
    expect(page).to have_no_content('08:00')
  end
end

describe('Rider view', {:type => :feature})do
  it('allows a rider to view all available trains')do
  train = Train.new(name: 'Yellow Line', direction: 'East-West')
  train.save
  city = City.new({name: 'Portland', state: 'OR'})
  city.save
  visit("/rider")
  expect(page).to have_content('Yellow Line')
  end
end

describe('Finding a train', {:type => :feature})do
  it('allows a rider to find if there is a train that goes to two cities')do
  train = Train.new(name: 'Yellow Line', direction: 'East-West')
  train.save
  city1 = City.new({name: 'Portland', state: 'OR'})
  city1.save
  city2 = City.new({name: 'Seattle', state: 'WA'})
  city2.save
  stop1 = Stop.new({train_id: train.id, city_id: city1.id, time: '23:00'})
  stop1.save
  stop2 = Stop.new({train_id: train.id, city_id: city2.id, time: '08:00'})
  stop2.save
  visit("/rider")
  select('Portland, OR', :from => 'start_city')
  select('Seattle, WA', :from => 'end_city')
  click_button('Find a Train')
  expect(page).to have_content('Yellow Line')
  end
end

describe('Purchasing a ticket', {:type => :feature})do
  it('allows a rider purcahse a ticket for a train that goes to desired destination')do
  train = Train.new(name: 'Yellow Line', direction: 'East-West')
  train.save
  city1 = City.new({name: 'Portland', state: 'OR'})
  city1.save
  city2 = City.new({name: 'Seattle', state: 'WA'})
  city2.save
  stop1 = Stop.new({train_id: train.id, city_id: city1.id, time: '23:00'})
  stop1.save
  stop2 = Stop.new({train_id: train.id, city_id: city2.id, time: '08:00'})
  stop2.save
  visit("/rider")
  select('Portland, OR', :from => 'start_city')
  select('Seattle, WA', :from => 'end_city')
  click_button('Find a Train')
  click_button('Purchase Ticket')
  fill_in('customer_name', :with => 'Paige')
  click_button('See your ticket')
  expect(page).to have_content('Paige')
  expect(page).to have_content('Yellow Line')
  expect(page).to have_content('Portland, OR')
  expect(page).to have_content('Seattle, WA')
  end
end
