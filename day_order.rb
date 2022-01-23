# frozen_string_literal: true

day = 0
month = 0
year = 0
loop do
  puts 'Введите дату в формате (dd.mm.yyyy): '
  day, month, year = gets.chomp.split('.').map(&:to_i)

  unless day.between?(1, 31)
    puts 'Такого числа не существует'
    next
  end
  unless month.between?(1, 12)
    puts 'Такого месяца не существует'
    next
  end
  unless year.between?(0, 3000)
    puts 'Год должен быть в интервале от 0 до 3000'
    next
  end

  break
end

months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
months[1] = 29 if ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?
day_of_the_year = day + months.take(month - 1).sum

puts "Сейчас #{day_of_the_year}-й день #{year} года"
