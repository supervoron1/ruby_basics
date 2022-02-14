# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

# Main class
class Main
  attr_reader :trains

  INDEX_ERROR = 'Вы ввели недопустимое значение. Попробуйте еще раз.'
  NOT_ENOUGH_STATIONS_ERROR = 'Сначала создайте станции, чтобы создавать маршруты (не менее 2)'
  NOT_DEFINED_ERROR = 'Пока не созданы'
  MIN_STATIONS_FOR_ROUTE_CREATION = 2
  TRAIN_TYPE_MENU = %w[Пассажирский Грузовой].freeze
  MENU_ITEMS = [
    'Создавать станции',
    'Создавать поезда',
    'Создавать маршруты',
    'Создавать вагоны',
    'Управлять станциями в маршруте (добавлять, удалять)',
    'Назначать маршрут поезду',
    'Добавлять вагоны к поезду',
    'Отцеплять вагоны от поезда',
    'Занять объем/место в вагоне',
    'Перемещать поезд по маршруту вперед и назад',
    'Просматривать список станций и список поездов на станции',
    'Посмотреть все станции, поезда и список созданных маршрутов',
    'seed data',
    'Выйти'
  ].freeze

  def initialize
    @trains = []
    @stations = []
    @routes = []
    @wagons = []
  end

  def start
    loop do
      puts_separator
      puts 'Программа управления железной дороги:'
      show_main_menu
      print 'Выберите пункт меню: '
      selected_menu = gets.to_i
      break if selected_menu == (MENU_ITEMS.length)

      puts_separator
      case selected_menu
      when 1 then create_station
      when 2 then create_train
      when 3 then create_route
      when 4 then create_wagon
      when 5 then route_menu
      when 6 then set_route_to_train
      when 7 then add_wagon_to_train
      when 8 then remove_wagon_from_train
      when 9 then occupy_wagon
      when 10 then move_train
      when 11 then show_trains_on_station
      when 12 then statistics
      when 13 then seed_data
      end
    end
  end

  def puts_separator
    puts '--------------------------------'
  end

  def show_main_menu
    MENU_ITEMS.each.with_index(1) { |item, index| puts "#{index} - #{item}" }
  end

  def show_train_types_menu
    TRAIN_TYPE_MENU.each.with_index(1) { |item, index| puts "#{index} - #{item}" }
  end

  def puts_stations
    puts 'Список станций:'
    puts NOT_DEFINED_ERROR if @stations.empty?
    @stations.each.with_index(1) do |station, index|
      puts "#{index} - #{station.name}"
    end
  end

  def puts_trains
    puts 'Список поездов:'
    puts NOT_DEFINED_ERROR if @trains.empty?
    @trains.each.with_index(1) do |train, index|
      puts "#{index} - №#{train.number} - Тип: #{train.type} - Вагонов: #{train.wagons.size}"
    end
  end

  def puts_routes
    puts 'Список маршрутов:'
    raise NOT_DEFINED_ERROR if @routes.empty?

    @routes.each.with_index(1) do |route, index|
      route_stations = route.stations.map(&:name).join(' -> ')
      puts "#{index} - #{route_stations}"
    end
  end

  def puts_wagons
    puts 'Список вагонов:'
    puts NOT_DEFINED_ERROR if @wagons.empty?
    @wagons.each.with_index(1) do |wagon, index|
      puts "#{index} - №#{wagon.number} - Тип: #{wagon.type} - Объем: (free/total) #{wagon.free_volume}/#{wagon.capacity}"
    end
  end

  protected

  def create_station
    puts 'Создать станцию:'
    print 'Название: '
    station_name = gets.chomp
    @stations << Station.new(station_name)
    puts "Станция '#{station_name}' создана."
  rescue StandardError => e
    puts e
    retry
  end

  # Method has been refactored => legacy
  # def create_train
  #   loop do
  #     puts 'Создать поезд:'
  #     puts '1 - Пассажирский'
  #     puts '2 - Грузовой'
  #     print 'Тип: '
  #     train_type = gets.to_i
  #
  #     next unless [1, 2].include?(train_type)
  #
  #     print 'Номер поезда: '
  #     train_number = gets.chomp
  #
  #     if train_type == 1
  #       @trains << PassengerTrain.new(train_number)
  #       puts "Пассажирский поезд '#{train_number}' создан."
  #     else
  #       @trains << CargoTrain.new(train_number)
  #       puts "Грузовой поезд '#{train_number}' создан."
  #     end
  #
  #     break
  #   end
  # end

  def create_train
    show_train_types_menu
    print 'Какой поезд хотите создать? '
    train_type = select_from_collection([CargoTrain, PassengerTrain])
    print 'Номер поезда: '
    train_number = gets.chomp
    @trains << train_type.new(train_number)
    puts "Создан поезд №#{train_number}, Тип: #{train_type}"
  rescue StandardError => e
    puts e
    retry
  end

  def select_from_collection(collection)
    index = gets.to_i - 1
    raise INDEX_ERROR unless index.between?(0, collection.size - 1)

    collection[index]
  end

  def create_route
    # raise NOT_ENOUGH_STATIONS_ERROR if @stations.length < 2
    if @stations.length < MIN_STATIONS_FOR_ROUTE_CREATION
      puts NOT_ENOUGH_STATIONS_ERROR
    else
      puts_stations
      puts 'Выберите начальную станцию'
      route_from = select_from_collection(@stations)
      puts 'Выберите конечную станцию'
      route_to = select_from_collection(@stations)
      # return if route_from.nil? || route_to.nil?    # made via exceptions
      # return if route_from == route_to
      @routes << Route.new(route_from, route_to)
      puts "Создан маршрут: #{route_from.name} -> #{route_to.name}."
    end
  rescue StandardError => e
    puts e
    retry
  end

  def create_wagon
    show_train_types_menu
    print 'Какой тип вагона хотите создать: '
    wagon_type = select_from_collection([PassengerWagon, CargoWagon])
    print 'Номер вагона: '
    wagon_number = gets.chomp
    print 'Задайте объем вагона: '
    wagon_capacity = gets.to_i
    @wagons << wagon_type.new(wagon_number, wagon_capacity)
    puts "Создан вагон №#{wagon_number}, Тип: #{wagon_type}, Свободный объем: #{wagon_capacity}"
  rescue StandardError => e
    puts e
    retry
  end

  def route_menu
    loop do
      puts '1 - Добавить промежуточную станцию'
      puts '2 - Удалить промежуточную станцию'
      puts '3 - Выйти'
      print 'Выберите действие: '
      route_menu_choice = gets.to_i

      case route_menu_choice
      when 1 then add_intermediate_station
      when 2 then remove_intermediate_station
      when 3 then break
      else puts 'Простите, я Вас не понял'
      end
      puts_separator
    end
  end

  def add_intermediate_station
    if @routes.empty?
      puts 'Сначала создайте маршрут'
    else
      puts 'Выберите маршрут для редактирования'
      route = choose_route
      if route.nil?
        puts 'Такого маршрута не существует!'
        return
      end
      puts 'Введите номер станции которую вы хотите добавить в маршрут'
      puts_stations
      station = select_from_collection(@stations)
      if station.nil?
        puts 'Такой станции не существует!'
        return
      end
      route.add_station(station)
      puts "Добавлена станция #{station.name} в маршрут: #{route.stations.map(&:name).join(' -> ')}."
    end
  end

  def remove_intermediate_station
    if @routes.empty?
      puts 'Сначала создайте маршрут'
    else
      puts 'Выберите маршрут для редактирования'
      route = choose_route
      if route.nil?
        puts 'Такого маршрута не существует!'
        return
      end
      puts 'Введите номер станции которую вы хотите удалить из маршрута'
      puts_stations
      station = select_from_collection(@stations)
      if station.nil?
        puts 'Такой станции не существует!'
        return
      end
      if route.first_station == station || route.last_station == station
        puts 'Нельзя удалить начальную или конечную станции'
        return
      end
      route.remove_station(station)
      puts "Удалена станция #{station.name} из маршрута: #{route.stations.map(&:name).join(' -> ')}."
    end
  end

  def set_route_to_train
    puts 'Назначить маршрут:'
    if @routes.empty? || @trains.empty?
      puts 'Сначала создайте маршрут и поезд!'
      return
    end
    train = choose_train
    puts "Выбран поезд '#{train.number}'"
    route = choose_route
    train.route = route
    puts "Поезду '#{train.number}' задан маршрут #{route.stations.map(&:name).join(' -> ')}."
  end

  def add_wagon_to_train
    if @trains.empty?
      puts 'Сначала создайте поезд!'
      return
    end
    puts 'Выберите поезд для работы'
    train = choose_train
    puts 'Выберите вагон для работы'
    wagon = choose_wagon
    raise INDEX_ERROR unless train.attachable_wagon?(wagon)

    train.add_wagon(wagon)
    puts "К поезду № #{train.number} добавлен вагон № #{wagon.number}, Тип - #{wagon.type}, Общий объем - #{wagon.capacity}"
    puts "Теперь у поезда #{train.wagons.size} вагон/ов"
    train.each_wagon { |wagon| puts "№#{wagon.number} - Объем: (free/total) #{wagon.free_volume}/#{wagon.capacity}" }
  rescue StandardError => e
    puts e
    retry
  end

  def remove_wagon_from_train
    if @trains.empty?
      puts 'Сначала создайте поезд!'
      return
    end
    puts 'Выберите поезд для работы'
    train = choose_train
    wagon = train.wagons.last
    train.remove_wagon(wagon)
    puts "Отцеплен вагон от поезда № #{train.number}, Тип - #{train.type}"
    puts "Теперь у поезда #{train.wagons.size} вагон/ов"
    train.each_wagon { |wagon| puts "№#{wagon.number} - Объем: (free/total) #{wagon.free_volume}/#{wagon.capacity}" }
  end

  def occupy_wagon
    puts 'Выберите вагон для работы'
    wagon = choose_wagon
    occupy_passenger_wagon(wagon) if wagon.is_a?(PassengerWagon)
    occupy_cargo_wagon(wagon) if wagon.is_a?(CargoWagon)
  end

  def occupy_passenger_wagon(wagon)
    raise INDEX_ERROR unless wagon.free_volume?

    wagon.take_seat
    puts_separator
    puts "Занято 1 место в вагоне №#{wagon.number}. Свободных мест: #{wagon.free_volume}"
  rescue StandardError => e
    puts e
  end

  def occupy_cargo_wagon(wagon)
    puts 'Введите объем загрузки'
    volume = gets.to_i.abs
    raise INDEX_ERROR unless volume <= wagon.free_volume

    wagon.take_volume(volume)
    puts_separator
    puts "Загружен объем: #{volume} в вагон №#{wagon.number}. Свободный объем: #{wagon.free_volume}"
  rescue StandardError => e
    puts e
  end

  def move_train
    puts 'Переместить поезд по маршруту:'
    train = choose_train

    if train.route.nil?
      puts 'Поезду не присвоен маршрут!'
    else
      puts '1 - Вперед'
      puts '2 - Назад'
      print 'Выберите действие: '
      train_action = gets.to_i

      case train_action
      when 1 then train.move_next_station
      when 2 then train.move_prev_station
      else puts 'Простите, я Вас не понял'
      end
    end
  end

  def show_trains_on_station
    puts 'Выберите интересующую станцию:'
    station = choose_station
    puts "Список поездов на станции #{station.name}:"
    if station.trains.any?
      station.each_train do |train, index|
        puts "#{index}: Поезд №#{train.number}, Тип - #{train.type}, Вагонов - #{train.wagons.length}:"
        train.each_wagon { |wagon| puts "№#{wagon.number} - Объем: (free/total) #{wagon.free_volume}/#{wagon.capacity}" }
      end
      # refactored thru `each.train` & `each_wagon` methods passed with block
      # station.trains.each.with_index(1) { |train, index| puts "#{index} - #{train.number}, Type - #{train.type}." }
    else
      puts "На станции #{station.name} поезда отсутствуют"
    end
  end

  def choose_route
    puts_routes
    print 'Выберите маршрут из списка: '
    select_from_collection(@routes)
  rescue StandardError => e
    puts e
    retry
  end

  def choose_train
    puts_trains
    print 'Выберите поезд из списка: '
    select_from_collection(@trains)
  rescue StandardError => e
    puts e
    retry
  end

  def choose_station
    puts_stations
    print 'Выберите станцию из списка: '
    select_from_collection(@stations)
  rescue StandardError => e
    puts e
    retry
  end

  def choose_wagon
    puts_wagons
    print 'Выберите вагон из списка: '
    select_from_collection(@wagons)
  rescue StandardError => e
    puts e
    retry
  end

  def statistics
    puts_routes
    puts_stations
    puts_trains
    puts_wagons
  end

  def generate_station
    @stations << Station.new('Moscow')
    @stations << Station.new('S.Petersburg')
    @stations << Station.new('Samara')
    @stations << Station.new('Perm')
    @stations << Station.new('Smolensk')
    @stations << Station.new('Minsk')
  end

  def generate_train
    @trains << PassengerTrain.new('999-PS')
    @trains << PassengerTrain.new('PAS-55')
    @trains << CargoTrain.new('777-CG')
  end

  def generate_wagons
    @wagons << PassengerWagon.new('11-999', 3)
    @wagons << PassengerWagon.new('99-888', 5)
    @wagons << CargoWagon.new('22-777', 220)
    @wagons << CargoWagon.new('55-222', 550)
  end

  def generate_routes
    @routes << Route.new(@stations.first, @stations.last)
  end

  def seed_data
    generate_station
    generate_train
    generate_wagons
    generate_routes
    puts 'Trains, Stations, Routes and Wagons seeded successfully'
  end

end

rr = Main.new
rr.start
