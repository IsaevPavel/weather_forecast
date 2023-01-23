require 'net/http'
require 'rexml/document'
require 'cgi'

# Подключаем класс MeteoserviceForecast
require_relative 'forecast'

URL = 'https://www.meteoservice.ru/export/gismeteo/point/34.xml'.freeze

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