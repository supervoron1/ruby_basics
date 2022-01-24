# frozen_string_literal: true

vowels = %w[а о э ы у я е ю и]
vowels_indexes = {}

('а'..'я').each.with_index do |letter, index|
  vowels_indexes[letter] = index + 1 if vowels.include? letter
end

puts vowels_indexes
