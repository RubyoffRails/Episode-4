require 'csv'
class ImportsData
	def import
		measurements = []
		CSV.foreach("fixtures/austin-weather-data.csv", headers: true) do |row|
			measurements << WeatherMeasurement.new(row.to_hash)
		end	
		return measurements
	end
end

class WeatherMeasurement

	attr_reader :rain, :temperature, :date
	def initialize(args)
		@rain = args.fetch("PrecipitationIn").to_f
		@temperature = args.fetch("Max TemperatureF").to_i
		@date = Date.parse(args.fetch("CDT"))
	end
	
end

class WeatherChart

	def create_to_file(file_path, measurements)
		html = create(measurements)
		File.open(file_path, "w") {|f| f.write(html) }
	end
	def create(measurements)
		template = File.open("templates/chart.html.template", "r") {|f| f.read}
		template.gsub("{{row-array}}", row_attributes(measurements))
	end
	private
	def get_template
	end
	
	def row_attributes(measurements)
		measurements.map{|measurement| "['#{measurement.date.strftime("%b%d")}', #{measurement.rain}, #{measurement.temperature}]"}.join(", ")
	end
end
