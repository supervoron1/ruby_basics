# frozen_string_literal: true

puts 'Как Вас зовут?'
name = gets.chomp.capitalize!
puts "#{name}, привет! Какой твой рост?"
height = gets.to_i
puts "#{name}, привет! Какой твой вес?"
weight = gets.to_i
ideal_weight = height - 110
if weight <= ideal_weight
  puts 'Ваш вес уже оптимальный'
else
  puts "Ваш идеальный вес: #{ideal_weight}"
end
