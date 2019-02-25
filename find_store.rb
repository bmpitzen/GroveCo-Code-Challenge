require 'docopt'
require 'httparty'
require 'csv'
require 'json'
require 'dotenv/load'
require 'pry'

@doc = <<DOCOPT
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

GOOGLE_REQUEST = 'https://maps.googleapis.com/maps/api/geocode/json?address='.freeze
KEY = ENV['KEY']
EARTH_RADIUS_KM = 6371
EARTH_RADIUS_MI = 3959
@closest_store = {}
@closest_distance = EARTH_RADIUS_MI

def parse_args
  @args = Docopt.docopt(@doc)
  @address = @args['--address']
  @zip = @args['--zip']
  @units = @args['--units']
  @output = @args['--output']
end

def address_or_zip
  if @address
    address_to_coordinates(@address)
  elsif @zip
    zip_to_coordinates(@zip)
  end
end

def zip_to_coordinates(zip)
  @url = GOOGLE_REQUEST + zip.to_s + KEY
  @zip_response = HTTParty.get(@url).parsed_response
  @zip_coords = @zip_response.dig('results')[0].dig('geometry', 'location')
  @loc1 = @zip_coords['lat'], @zip_coords['lng']
end

def address_to_coordinates(address)
  address.gsub!(/[ ]/, '+')
  @url = GOOGLE_REQUEST + address + KEY
  @addr_response = HTTParty.get(@url).parsed_response
  @addr_coords = @addr_response.dig('results')[0].dig('geometry', 'location')
  @loc1 = @addr_coords['lat'], @addr_coords['lng']
end

def units
  @closest_distance =
    if @units == 'km'
      "#{(@closest_distance * 1.609344).round(2)} km"
    else
      "#{@closest_distance.round(2)} mi"
    end
end

def output
  if @output == 'json'
    @closest_store[:Distance] = @closest_distance
    puts JSON.pretty_generate @closest_store
  else
    @store_name = @closest_store.dig('Store Name')
    @store_address = "#{@closest_store.dig('Address')}, \
#{@closest_store.dig('City')}, \
#{@closest_store.dig('State')}, \
#{@closest_store.dig('Zip Code')}"
    puts "The nearest store to your provided location is #{@store_name} at \
#{@store_address} and it is #{@closest_distance} away."
  end
end

def main
  parse_args
  address_or_zip
  closest_store(@loc1)
  units
  output
end

def closest_store(loc1)
  CSV.foreach './store-locations.csv', headers: true do |row|
    store = row.to_h
    store_coords = [store.dig('Latitude').to_f, store.dig('Longitude').to_f]
    distance_to_store = haversine(loc1, store_coords)
    if distance_to_store < @closest_distance
      @closest_distance = distance_to_store
      @closest_store = store
    end
  end
end

def radians(loc1, loc2)
  rad_per_deg = Math::PI / 180
  @dlat_rad = (loc2[0] - loc1[0]) * rad_per_deg
  @dlon_rad = (loc2[1] - loc1[1]) * rad_per_deg
  @lat1_rad = loc1[0] * rad_per_deg
  @lat2_rad = loc2[0] * rad_per_deg
end

def haversine(loc1, loc2)
  radians(loc1, loc2)
  m = Math
  a = m.sin(@dlat_rad/2)**2 +
      m.cos(@lat1_rad) * m.cos(@lat2_rad) *
      (m.sin(@dlon_rad/2)**2)
  c = 2 * m.atan2(m.sqrt(a), m.sqrt(1 - a))
  c * EARTH_RADIUS_MI
end

main
# pry
