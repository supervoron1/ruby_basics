# frozen_string_literal: true

puts 'Введите коэфициент a'
factor_a = gets.to_f
puts 'Введите коэфициент b'
factor_b = gets.to_f
puts 'Введите коэфициент c'
factor_c = gets.to_f
discriminant = ((factor_b**2) - (4 * factor_a * factor_c))
if discriminant.negative?
  puts "Дискриминант = #{discriminant} Корней нет."
elsif discriminant.positive?
  square_root = Math.sqrt(discriminant)
  x1 = (-factor_b + square_root) / (2.0 * factor_a)
  x2 = (-factor_b - square_root) / (2.0 * factor_a)
  puts "Дискриминант = #{discriminant} Корень1 = #{x1} Корень2 = #{x2}"
else # discriminant = 0
  square_root = Math.sqrt(discriminant)
  x1 = (-factor_b + square_root) / (2.0 * factor_a)
  puts "Дискриминант = #{discriminant} Корень = #{x1}"
end
