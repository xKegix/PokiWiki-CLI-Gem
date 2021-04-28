require 'pry'
require 'json'
require 'httparty'

require_relative 'pokemon.rb'

class Api
    attr_accessor :search

    def initialize(search)
        @search = search
    end 

    def self.fetch_names_http
      url = "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=101"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      json = JSON.parse(response)
      json["results"].collect { |name|name["name"] }
    end

    def fetch_pokemon_info
        url = "https://pokeapi.co/api/v2/pokemon/#{search}/"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        json = JSON.parse(response)
        pokemon_attributes = {
          :name=> json["name"],      
          :height => json["height"], 
          :weight => json["weight"],
          :moves => (json["moves"].collect {|move| move["move"]["name"]})[1..10]
         }
    end

    def create_pokemon
        attributes = self.fetch_pokemon_info
        pokemon = Pokemon.new(attributes)
        pokemon 
    end 

end