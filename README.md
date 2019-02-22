# find_store.rb

This is a project designed to find the nearest store to the provided location (as the crow flies) and print the matching store's information and distance. It converts a user's location into coordinates using the Google Geocoding API and compares it (using the [Haversine formula](https://www.movable-type.co.uk/scripts/latlong.html)) to a list of stores in the store-locations.csv document and returns the nearest location to the user. 

## Prerequisites 

This programs makes a few assumptions. This assumes you have Ruby installed on your machine. If you do not, follow the steps [here](https://www.ruby-lang.org/en/documentation/installation/) to install ruby. find_store is also dependent on the following gems: [docopt](https://github.com/docopt/docopt.rb), [httparty](https://github.com/jnunemaker/httparty), [csv](https://github.com/ruby/csv), [json](https://github.com/ruby/json), and [dotenv](https://github.com/bkeepers/dotenv). To ensure that these are all installed on your machine, run `gem install docopt httparty csv json dotenv` in your terminal. 

## Usage 

```
Usage:
  find_store --address="<address>"
  find_store --address="<address>" [--units=(mi|km)] [--output=text|json]
  find_store --zip=<zip>
  find_store --zip=<zip> [--units=(mi|km)] [--output=text|json]

Options:
  --zip=<zip>               Find nearest store to this zip code. If there are multiple best-matches, return the first.
  --address=<address>       Find nearest store to this address. If there are multiple best-matches, return the first.
  --units=(mi|km)           Display units in miles or kilometers [default: mi]
  --output=(text|json)      Output in human-readable text, or in JSON (e.g. machine-readable)[default: text]
  -h, --help               Show this message.

Example
  find_store --address='1770 Union St, San Francisco, CA 94123'
  find_store --zip=94115 --units=km
```