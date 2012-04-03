#! /usr/local/env ruby

require "./austin-data"
measurements = ImportsData.new.import
WeatherChart.new.create_to_file "austin.html", measurements
STDOUT.write "Created austin.html\n"
exit 0
