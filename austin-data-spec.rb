# Our Spec File starting point
require "./austin-data"

describe ImportsData do
	it "should have 366 entries" do
		ImportsData.new.import.count.should eq(366)
	end

	it "should return a WeatherMeasurement" do
		ImportsData.new.import.first.should be_a(WeatherMeasurement)
	end

	it "should have the right measurements for nov 28" do
		measurements = ImportsData.new.import
		nov_28 = measurements.select{|measurement| measurement if measurement.date == Date.parse("2011-11-28")}.first
		nov_28.rain.should eq(0.00)
		nov_28.temperature.should eq(63)
	end
end

describe WeatherMeasurement do
	let(:weather_data) { {"PrecipitationIn" => "0.10", "Max TemperatureF" => 95, "CDT" => "2011-3-28"} } 

	it "fetches rain and stores it" do
		WeatherMeasurement.new(weather_data).rain.should eq(0.10)
	end
	it "fetches the temperature and stores it" do
		WeatherMeasurement.new(weather_data).temperature.should eq(95)
	end
	it "fetches the date and stores id" do
		WeatherMeasurement.new(weather_data).date.should eq(Date.parse("2011-03-28"))
	end
end

describe WeatherChart do
	let(:measurements) { [ stub({:rain => 0.0, :temperature => 64, :date => Date.parse("2011-03-28")}) ]}
	it "should create an array of data points" do
		WeatherChart.new.create( measurements ).should include "['Mar28', 0.0, 64]"
	end

	it "should get the template" do
		WeatherChart.new.create( measurements).should include "google.visualization.LineChart"
	end

	let(:file_path) { "/tmp/austin_chart.html"} # c:\tmp\austin_chart.html
	let(:fake_html) { "fake-html" }
	it "should write to a file" do
		chart = WeatherChart.new
		chart.stub(:create) { fake_html }
		file_mock = mock("file")
		file_mock.stub(:write).with(fake_html)
		File.should_receive(:open).with(file_path, "w") { file_mock }
		chart.create_to_file(file_path, measurements)
	end
end
