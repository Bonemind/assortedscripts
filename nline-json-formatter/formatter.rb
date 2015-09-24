#!/usr/bin/env ruby
require 'json'
require 'pp'

# A simple utility that keeps reading data
# Reads the data line by line, and expects 
# it to be json in one line
# Formats it and pp's it
while input = ARGF.gets
  input.each_line do |line|
    parsed = JSON.parse(line)
    begin
      $stdout.puts "-" * 80
      pp parsed
      $stdout.puts "-" * 80
    rescue Errno::EPIPE
      exit(74)
    end
  end
end
