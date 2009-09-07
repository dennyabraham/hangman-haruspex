module Haruspex
  class Haruspex

    # You may initialize you player but the the initialize method must take NO paramters.
    # The player will only be instantiated once, and will play many games.
    def initialize
    end

    # Before starting a game, this method will be called to inform the player of all the possible words that may be
    # played.
    def word_list=(list)
      @@ORIGINAL_DICTIONARY = list
    end

    # a new game has started.  The number of guesses the player has left is passed in (default 6),
    # in case you want to keep track of it.
    def new_game(guesses_left)
      @remaining = ('a'..'z').to_a
      @dictionary = @@ORIGINAL_DICTIONARY.dup
    end

    # Each turn your player must make a guess.  The word will be a bunch of underscores, one for each letter in the word.
    # after your first turn, correct guesses will appear in the word parameter.  If the word was "shoes" and you guessed "s",
    # the word parameter would be "s___s", if you then guess 'o', the next turn it would be "s_o_s", and so on.
    # guesses_left is how many guesses you have left before your player is hung.
    def guess(word, guesses_left)
      filter_dictionary_using word
      letter_counts = count_occurrences
      answer = most_common_in letter_counts
      @remaining.delete answer
      return answer
    end

    def count_occurrences
      occurrences = {}
      for letter in @remaining do
        occurrences[letter] = @dictionary.find_all{|word| word.include? letter}.size
      end
      return occurrences
    end

    def filter_dictionary_using word
      @dictionary.delete_if{|entry| entry.size != word.size }
      @dictionary.delete_if{|entry| !entry.match(Regexp.new(word.gsub('_', '\w')))}
    end

    def most_common_in letter_counts
      max_occurrences = letter_counts.values.max
      return letter_counts.find{|letter, occurrences| occurrences == max_occurrences }.first
    end

    # notifies you that your last guess was incorrect, and passes your guess back to the method
    def incorrect_guess(guess)
      @dictionary.delete_if{|entry| entry.include? guess }
    end

    # notifies you that your last guess was correct, and passes your guess back to the method
    def correct_guess(guess)
      @dictionary.delete_if{|entry| !entry.include? guess }
    end

    # you lost the game.  The reason is in the reason parameter
    def fail(reason)
    end

    # The result of the game, it'll be one of 'win', 'loss', or 'fail'.
    # The spelled out word will be provided regardless of the result.
    def game_result(result, word)
    end
  end
end