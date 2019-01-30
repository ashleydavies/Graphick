#! /usr/bin/env ruby
# Generates pairs of (i, v) for i increasing and v = i * ARGV[0]

input = ARGV[0].to_f

10.times do |i|
	puts "#{i+1}, #{(i+1) * input}"
end


