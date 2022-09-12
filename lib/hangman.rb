class Hangman
    def initialize
        @mistakes = 0
        @correct_letters = Array.new
        @incorrect_letters = Array.new
        @word = ""
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

    def play
        choose_word
        puts @word
    end

    def turn
    end
end

game = Hangman.new
game.play
