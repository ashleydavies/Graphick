#! /usr/bin/env ruby
# Generates pairs of (i, v) for i increasing and v = i * ARGV[0]

input = ARGV[0].to_f unless ARGV.length == 0
input = ARGV[0].to_i unless ARGV.length == 0 && (not ARGV[0].include? ".")
input = 1 if input.nil?

10.times do |i|
	puts "#{i+1}, #{(i+1) * input}"
end


