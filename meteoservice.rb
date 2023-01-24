require 'net/http'
require 'rexml/document'
require 'cgi'

# Подключаем класс MeteoserviceForecast
require_relative 'forecast'

choices = Forecast.city.keys

puts "Погоду для какого города Вы хотите узнать?"
choices.each_with_index { |name, index| puts "#{index + 1}. #{name}" }
choice = STDIN.gets.chomp.to_i

until choice.between?(1, choices.size)
  puts "Введите число от 1 до #{choices.size}"
  choices.each_with_index do |name, index|
    puts "#{index + 1}. #{name}"
  end
  choice = STDIN.gets.chomp.to_i
end

request_xml = Forecast.city_xml(choices[choice - 1])
URL = "https://www.meteoservice.ru/export/gismeteo/point/#{request_xml}.xml"

response = Net::HTTP.get_response(URI.parse(URL))
doc = REXML::Document.new(response.body)

city_name = CGI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])

# Достаем все XML-теги <FORECAST> внутри тега <TOWN> и преобразуем их в массив
forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

# Выводим название города и все прогнозы по порядку
puts city_name
puts

forecast_nodes.each do |node|
  puts Forecast.from_xml(node)
  puts
end