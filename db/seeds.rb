require 'http'
require 'json'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Image.destroy_all

body = HTTP.get('https://developer.nps.gov/api/v1/parks?fields=fullName,images,description,states&limit=100&api_key=FgGdhhL5SPzrAxDjtp8fJhqeG8KgUWSfHet86gzJ').parse

# data = JSON.parse(body)

body['data'].each do |park|
  if park['fullName'] =~ /Park|Preserve/ && park['images'] && !park['images'].empty?
    random_pick = rand(park['images'].length)
    Image.create!(name: park['fullName'], url: park['images'][random_pick]['url'])
  end
end
