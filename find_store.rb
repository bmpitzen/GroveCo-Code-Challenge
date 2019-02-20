require 'docopt'
require 'pp'
require 'pry'
require 'httparty'
require 'csv'


doc = <<DOCOPT

Usage:
  #{__FILE__} --address='<address>'
  #{__FILE__} --address='<address>' [--units=(mi|km)] [--output=text|json]
  #{__FILE__} --zip='<zip>'
  #{__FILE__} --zip='<zip>' [--units=(mi|km)] [--output=text|json]

Options:
  --zip=<zip>               Find nearest store to this zip code. If there are multiple best-matches, return the first.
  --address=<address>       Find nearest store to this address. If there are multiple best-matches, return the first.
  --units=(mi|km)           Display units in miles or kilometers [default: mi]
  --output=(text|json)      Output in human-readable text, or in JSON (e.g. machine-readable) [default: text]
   -h, --help               Show this message.

DOCOPT

GOOGLE_REQUEST = 'https://maps.googleapis.com/maps/api/geocode/json?address='
KEY = '&key=AIzaSyDfg9Hyqk7U5wIJP6ZaWaYkBu5Si35iKQQ'
EARTH_RADIUS_KM = 6371
EARTH_RADIUS_MI = 3959


@args = Docopt.docopt(doc)
@address = @args['--address']
@zip = @args['--zip']
@units = @args['--units']
@output = @args['--output']

def main

  if @address
    address_to_coordinates(@address)
    puts @loc1
  elsif @zip
    zip_to_coordinates(@zip)
    puts @loc1
  else
    puts 'Error'
  end

end

def address_to_coordinates(address)
  address.gsub!(/[ ]/, '+')
  @url = GOOGLE_REQUEST + address + KEY
  @addr_response = HTTParty.get(@url).parsed_response
  @addr_coords = @addr_response.dig('results')[0].dig('geometry', 'location')
  @loc1 = @addr_coords['lat'], @addr_coords['lng']
end

def zip_to_coordinates(zip)
  @url = GOOGLE_REQUEST + zip.to_s + KEY
  @zip_response = HTTParty.get(@url).parsed_response
  @zip_coords = @zip_response.dig('results')[0].dig('geometry', 'location')
  @loc1 = @zip_coords['lat'], @zip_coords['lng']
end

def stores
  @store_array = []
  @store_coords = []
  CSV.foreach './store-locations.csv', headers: true do |row|
    store = row.to_h
    str_zip = store.dig('Zip Code')
    lat = store.dig('Latitude')
    lng = store.dig('Longitude')
    @store_array << store
    @store_coords << [str_zip, lat, lng]
  end
end

def haversine(loc1, loc2)
  rad_per_deg = Math::PI / 180

  dlat_rad = (loc2[0] - loc1[0]) * rad_per_deg
  dlon_rad = (loc2[1] - loc1[1]) * rad_per_deg

  lat1_rad = loc1[0] * rad_per_deg
  lat2_rad = loc2[0] * rad_per_deg

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2)**2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

  c * EARTH_RADIUS_MI
end


main

