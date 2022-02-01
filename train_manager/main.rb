# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Main
  attr_reader :trains

  MENU_ITEMS = [
    'Создавать станции',
    'Создавать поезда',
    'Создавать маршруты',
    'Управлять станциями в маршруте (добавлять, удалять)',
    'Назначать маршрут поезду',
    'Добавлять вагоны к поезду',
    'Отцеплять вагоны от поезда',
    'Перемещать поезд по маршруту вперед и назад',
    'Просматривать список станций и список поездов на станции',
    'Посмотреть все станции, поезда и список созданных маршрутов',
    'generate random data',
    'Выйти'
  ].freeze

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
      when 4 then route_menu
      when 5 then set_route_to_train
      when 6 then add_wagon_to_train
      when 7 then remove_wagon_from_train
      when 8 then move_train
      when 9 then browse_trains_in_station
      when 11 then generate_data
      end
    end
  end

  def puts_separator
    puts '--------------------------------'
  end

  def show_main_menu
    MENU_ITEMS.each.with_index(1) { |el, idx| puts "#{idx} - #{el}" }
  end

  def create_station
    puts 'create'
  end

  def create_train
  end

  def create_route
  end
  end

  def route_menu
  end

  def set_route_to_train
  end

  def add_wagon_to_train
  end

  def remove_wagon_from_train
  end

  def move_train
  end

  def browse_trains_in_station
  end

  def generate_data
  end

rr = Main.new
rr.start
