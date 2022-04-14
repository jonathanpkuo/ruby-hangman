module Hangman

    class Hangman_Game
        attr_accessor :target_word, :progress, :guess_count

        def initialize(target_word, guess_count=0, progress=Array.new(target_word.length))
            @target_word = target_word
            @guess_count = guess_count
            @progress = progress
            @input_buffer = []
        end

        def print_status
            puts "@target_word is #{@target_word} \n @guess_count is #{guess_count} \n @progress is #{progress} \n @input_buffer is #{@input_buffer}."
        end

        def take_input()
            @input_buffer.clear() if input_buffer.length > 0
            @input_buffer.push(STDIN.getch)
        end
        
        def game_play_loop
            until (@guess_count == 6)
                
            end
        end

        def game_menu()
            puts "MENU"
            puts "- 1 - Save Game"
            puts "- 2 - Return to Game"
            puts "- 3 - Return to Main Menu"
            puts "- 4 - Quit"
            take_input()
            case @input_buffer[0]
            when "1"
                filename = gets.chomp()
                save_game(filename)
            when "2"

            when "3"

            when "4"
                exit
            else 
                puts "Invalid Input"
                game_menu()
            end
        end

        def to_yaml
            YAML.dump ({
                :guess_count => @guess_count,
                :target_word => @target_word,
                :progress => @progress
            })
        end

        def save_game(string)
            filename = "#{string.downcase}.yaml"
            File.open(filename, 'w') { |file| file.write(self.to_yaml)}
        end

        def self.load_game(file)
            data = YAML.load(File.read(file))
            self.new(data[:target_word], data[:guess_count], data[:progress])
        end
    end

    class Display_IO
        attr_accessor :io_buffer

        def initialize
            @io_buffer = []
            @wb = Hangman::Word_Bank.new()
        end

        def acquire_input()
            @io_buffer.clear() if @io_buffer.length > 0
            @io_buffer.push(STDIN.getch)
        end

        def main_menu()
            puts "- 1 - New Game"
            puts "- 2 - Load Game"
            puts "- 3 - Exit"
            acquire_input()
            case @io_buffer[0]
            when "1"
                game = Hangman::Hangman_Game.new(@wb.word_picker)
                game.print_status
                main_menu()
            when "2"
                load_game_menu()
                main_menu()
            when "3"
                exit
            else
                puts "Invalid Entry"
                main_menu()
            end
        end

        def load_game_menu()
            filelist = Dir.glob("saves/*.yaml")
        end

    end
    
    class Word_Bank
        def initialize()
            @dictionary = Array.new()
            populate
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

dis = Hangman::Display_IO.new()
dis.main_menu()