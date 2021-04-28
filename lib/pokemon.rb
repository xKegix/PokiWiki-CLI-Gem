require 'pry'

class Pokemon
    attr_accessor :name, :height, :weight, :moves

    @@all_pokemon = []

    def initialize(attributes)
        attributes.each{|key,value| self.send("#{key}=", value)}
        @@all_pokemon << self
    end
    
    def self.all 
        @@all_pokemon
    end

    def self.find_or_create_pokemon(search)
        pokemon = Pokemon.all.find{|pokemon| pokemon.name == search}
        if pokemon 
            pokemon
        else 
            api = Api.new(search)
            new_pokemon = api.create_pokemon
            new_pokemon
        end
    end 

end