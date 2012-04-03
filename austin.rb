#!/usr/bin/env ruby

require "./austin-data"
measurements = ImportsData.new.import
WeatherChart.new.create_to_file "/tmp/austin.html", measurements
STDOUT.write "Written to #{"/tmp/austin.html"}"
STDOUT.write "\n"
STDOUT.flush
exit 0
