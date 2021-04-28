require 'pry'
require "tty-prompt"
require 'colorize'

class Cli

    @@option = []  # store pokemon into class array.

    def self.logo
        puts "     POKIWIKI     ".colorize(:red).on_blue.underline
    end

    def run
        puts "Please select a Pokemon. Enter 1-101.".colorize(:blue) # ask user to select a pokemon.
        self.show_option # show options of pokemon.
        user_input = gets.strip # get and store user input.
        index = input_to_index(user_input)  # turn user input into integer make method -  index = user_input.to_i - 1 .
        
                # binding.pry

        # if index is not between 0 - 100 
        if !index.between?(0,100)
            # tell user to only press 1-101
            puts "Please only enter 1-101, press enter to go back:".colorize(:red)
            #put output into user input
            user_input = gets.strip
            # turn into index
            index = input_to_index(user_input)
        else
            puts "----------------------------------------------".colorize(:yellow)
            puts "The Pokemon's details are:".colorize(:green)
        end

        search = Cli.option[index] # selected index of the pokemon into variable.
        api = Api.new(search) # look up that pokemon on api to get data.
        pokemon = Pokemon.find_or_create_pokemon(search) # find the pokemon.
        self.searched_pokemon(pokemon) # show all data on that pokemon
        self.menu
    end
    

    def input_to_index(user_input) 
        user_input.to_i - 1
    end

    def self.option # get data from api assign to and show.
        @@option = Api.fetch_names_http
        @@option.sort
    end

    def show_option  # iterate over pokemon with its index and add consecutive number + name.
        Cli.option.each_with_index{|option, index| puts "#{index + 1}. #{option}"} 
    end

    def random_pokemon
        search = Cli.option.sample
        api = Api.new(search)
        pokemon = Pokemon.find_or_create_pokemon(search)
        self.searched_pokemon(pokemon) 
        self.menu
    end

    def clear_history
        Pokemon.all.clear
        puts "Empty History"
        self.menu
    end

    def searched_pokemon(pokemon)
        puts "----------------------------------------------".colorize(:yellow)
        puts "Name: #{   pokemon.name.upcase   }".colorize(:blue)
            puts "  height:" + " #{pokemon.height}"
            puts "  weight:" + " #{pokemon.weight}"
            puts "  moves:" + " #{pokemon.moves.join(", ")}"
    end

    def all_pokemon
        puts "----------------------------------------------".colorize(:yellow)
        Pokemon.all.each {|pokemon| puts "You have searched: #{pokemon.name.upcase}".colorize(:light_blue)
        puts "  height:" + " #{pokemon.height}"
        puts "  weight:" + " #{pokemon.weight}"
        puts "  moves:" + " #{pokemon.moves.join(", ")}"

    }
    end

    def menu
        puts "1. Search another Pokemon? 2. Search History. 3. Exit! 4. RANDOM! 5. Clear History."
        input = gets.strip
            case input 
            when '1'
                self.run
            when '2'
                self.all_pokemon
                menu
            when '3'
                self.exit
            when '4'
                self.random_pokemon
            when '5'
                self.clear_history
            else
                puts "1, 2, 3 options only!"
                self.menu
            end

        end

        def exit 
            puts "Thanks You for using PokiWiki ;)!!!".colorize(:red)
        end
    end