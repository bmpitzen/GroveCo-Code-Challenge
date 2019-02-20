require 'docopt'
require 'pp'
require 'pry'

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

args = Docopt.docopt(doc)
address = args['--address']
zip = args['--zip']
units = args['--units']
output = args['--output']

def address_to_coordinates(address)
  address.gsub!(/[ ]/, '+')
  @url = GOOGLE_REQUEST + address + KEY
  @addr_response = HTTParty.get(@url).parsed_response
  @addr_coords = @addr_response.dig('results')[0].dig('geometry', 'location')
end

def zip_to_coordinates(zip)
  @url = GOOGLE_REQUEST + zip + KEY
  @zip_response = HTTParty.get(@url).parsed_response
  @zip_coords = @zip_response.dig('results')[0].dig('geometry', 'location')
end
