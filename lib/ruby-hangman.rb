require 'digest'

module Hangman
    class Hangman_Game
        def initialize(target_word)
            @game_name
            @guesses_remaining
            @target_word
            @progress
        end

        def save_game()

        end

        def load_game()

        end
    end

    class Menus

    end
    
    class Word_Bank
        def initialize()
            @dictionary = Array.new()
        end

        def print_dictionary
            puts @dictionary
        end

        def populate
            input = File.open('./google-10000-english-no-swears.txt', 'r') do |file|
                while line = file.gets
                    # isolate lines with length >= 5 and <= 12
                    if (line.chomp.length >= 5 && line.chomp.length <= 12)
                        # add to dictionary array
                        @dictionary.push(line.chomp)
                    end
                end
            end
        end
        
        def word_picker
            @dictionary[rand(0..@dictionary.length)]
        end
    end

end

game = Hangman::Word_Bank.new()
