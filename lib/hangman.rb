class Hangman
    def initialize
        @mistakes = 0
        @incorrect_letters = Array.new
        @word_letters = Array.new
        @empty_array = Array.new
        @positions = Array.new
        @word = ""
        @guess = ""
        @turn = 0
    end

    def choose_word
        fname = "google-10000-english-no-swears.txt"
        file = File.open(fname, "r")
        random_word = file.readlines.sample
        if random_word.length > 4 && random_word.length < 13
            @word = random_word
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
        choose_word
        puts @word
        empty_word
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
        puts "Enter a letter"
        @guess = gets.chomp.downcase
        guess_letter
        empty_guess
    end

    def save_game
    end

    def load_game
    end
end

game = Hangman.new
game.play
