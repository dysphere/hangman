require "json"

class Hangman
    attr_accessor :mistakes, :incorrect_letters, :word_letters,
    :empty_array, :positions, :word, :guess, :turn

    def initialize(mistakes=0, incorrect_letters=[],
    word_letters=[], empty_array=[], positions=[],
    word="", guess="", turn=0)
        @mistakes = mistakes
        @incorrect_letters = incorrect_letters
        @word_letters = word_letters
        @empty_array = empty_array
        @positions = positions
        @word = word
        @guess = guess
        @turn = turn
    end

    def choose_word
        fname = "google-10000-english-no-swears.txt"
        file = File.open(fname, "r")
        random_word = file.readlines.sample
        if random_word.length > 4 && random_word.length < 13
            @word = random_word.chomp
        else
            choose_word
        end
    end

    def empty_word
        @word_letters = @word.chomp.split("")
        @empty_array = @word_letters.map do |letter|
            letter = "—"
        end
        puts @empty_array.join(" ")
    end

    def play
        puts "Do you want to load a game? (y/n)"
        answer = gets.chomp.downcase
        if answer == "y"
            puts "Enter the name of your save"
            save_name = gets.chomp
            save_file = File.open("#{save_name}.json", "r")
            save_data = save_file.read
            load_file = Hangman.from_json(save_data)
            load_file.continue_play
        else
            choose_word
            empty_word
            while @mistakes < 7 && @empty_array != @word_letters
                turn
                puts "Mistakes: #{@mistakes}/7"
                puts @empty_array.join(" ")
                @turn += 1
            end
        end
    end

    def continue_play
        puts @empty_array.join(" ")
        while @mistakes < 7 && @empty_array != @word_letters
            turn
            puts "Mistakes: #{@mistakes}/7"
            puts @empty_array.join(" ")
            @turn += 1
        end
    end

    def guess_letter
        if @word_letters.include?(@guess)
            @word_letters.each_with_index do |letter, index|
                if letter == @guess
                    @positions.push(index)
                end
            end
            @positions.each do |position|
                @empty_array.delete_at(position)
                @empty_array.insert(position, @guess)
            end
        else
            @incorrect_letters.push(@guess)
            @mistakes += 1
        end
    end

    def empty_guess
        @guess = ""
        @positions = []
    end

    def turn
        save_game
        puts "Enter a letter"
        @guess = gets.chomp.downcase
        guess_letter
        empty_guess
    end

    def to_json
        JSON.dump ({
            :mistakes => @mistakes,
            :incorrect_letters => @incorrect_letters,
            :word_letters => @word_letters,
            :empty_array => @empty_array,
            :positions => @positions,
            :word => @word,
            :guess => @guess,
            :turn => @turn
        })
    end

    def save_game
        puts "Do you want to save your game? (y/n)"
        answer = gets.chomp.downcase
        if answer == "y"
            puts "Enter a unique name for your savefile"
            save_name = gets.chomp
            save = Hangman.new(@mistakes, @incorrect_letters,
            @word_letters, @empty_array, @positions, 
            @word, @guess, @turn)
            File.open("#{save_name}.json", "w") do |f|
                f.puts(save.to_json)
            end
        end
    end

    def self.from_json(string)
        data = JSON.load string
        new_object = self.new(data['mistakes'], data['incorrect_letters'],
        data['word_letters'], data['empty_array'], 
        data['positions'], data['word'], data['guess'],
        data['turn'])
    end
end

game = Hangman.new
game.play
