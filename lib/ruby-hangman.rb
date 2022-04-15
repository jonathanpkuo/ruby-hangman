require 'yaml'

module Hangman

    class Hangman_Game
        attr_accessor :target_word, :progress, :chance_count

        def initialize(target_word, chance_count=6, progress=Array.new(target_word.length, "_"), wrong_guesses=Array.new())
            @target_word = target_word
            @chance_count = chance_count
            @progress = progress
            @wordsplit = target_word.chars
            @input_buffer = []
            @wrong_guesses = wrong_guesses
        end

        # Debug statement 
        def print_status 
            puts "@target_word is #{@target_word} \n @chance_count is #{chance_count} \n @progress is #{progress} \n @input_buffer is #{@input_buffer}."
        end

        # "Standard input function"
        def take_input()
            @input_buffer.clear() if @input_buffer.length > 0
            @input_buffer.push(STDIN.getch)
        end
        
        def game_play_loop
            # 2 procs for case-switch, using regex /[0-9]/ for nubmers & /[a-z]/ for letters (downcased)
            number_proc = Proc.new { |x| x.match?(/[0-9]/)}
            letter_proc = Proc.new { |x| x.downcase.match?(/[a-z]/)}
            # If-then-elsif for primary gameplay loop
            # Initial check to see if game is over (lose) gets is to pause
            if @chance_count == 0
                puts "Game Over! You Lose!"
                STDIN.getch
                return
            # Secondary check for if game is over (win) gets is to pause
            elsif @progress.join == @target_word
                puts "Progress so far: #{@progress.join(" ")}"
                puts "Game Over! You Win!"
                STDIN.getch
                return
            # If no game over condition is true, allow for guess.
            else
                # Basic info statements
                puts "#{@chance_count} chances remaining."
                puts "Former guesses: #{@wrong_guesses}"
                puts "Input Letter or Number (for menu)"
                puts "Progress so far: #{@progress.join(" ")}"
                # Input and case/switch
                take_input()
                case @input_buffer[0]
                when number_proc
                    game_menu()
                when letter_proc
                    letter_entry(@input_buffer[0])
                end
            end
            # Call self to loop
            self.game_play_loop
        end
        
        def letter_entry(letter)
            if @wordsplit.any?(letter)
                @wordsplit.each_with_index do |chars, index|
                    @progress[index] = letter if chars == letter
                end
            else
                @wrong_guesses.push(letter)
                @chance_count -= 1
            end
        end

        # "In-game" Menu to allow for saving
        def game_menu()
            puts "MENU"
            puts "- 1 - Save Game"
            puts "- 2 - Return to Game"
            puts "- 3 - Return to Main Menu"
            puts "- 4 - Quit"
            take_input()
            case @input_buffer[0]
            when "1"
                puts "please name your save:"
                filename = gets.chomp()
                save_game(filename)
            when "2"
                self.game_play_loop
            when "3"
                return
            when "4"
                exit
            else 
                puts "Invalid Input"
                game_menu()
            end
        end

        def to_yaml
            YAML.dump ({
                :chance_count => @chance_count,
                :target_word => @target_word,
                :progress => @progress,
                :wrong_guesses => @wrong_guesses
            })
        end

        def save_game(string)
            filename = "saves/#{string.downcase}.yaml"
            File.open(filename, 'w') { |file| file.write(self.to_yaml)}
        end

        def self.load_game(file)
            data = YAML.load(File.read(file))
            self.new(data[:target_word], data[:chance_count], data[:progress], data[:wrong_guesses])
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
                game.game_play_loop
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