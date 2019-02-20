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


# begin
#   pp Docopt.docopt(doc, version: '1.2.3')
# rescue Docopt::Exit => e
#   puts e.message
# end


