require 'digest'

module Hangman
    class Hangman_Game
        attr_accessor :target_word, :progress, :guess_count
        def initialize(target_word, guess_count=0, progress=Array.new(target_word.length))
            @target_word = target_word
            @guess_count = guess_count
            @progress = progress
        end

        def to_yaml
            YAML.dump ({
                :guess_count => @guess_count,
                :target_word => @target_word,
                :progress => @progress
            })
        end

        def save_game()
            filename = "#{@game_name.downcase}.yaml"
            File.open(filename, 'w') { |file| file.write(self.to_yaml)}
        end

        def self.load_game(file)
            data = YAML.load(File.read(file))
            self.new(data[:target_word], data[:guess_count], data[:progress])
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
