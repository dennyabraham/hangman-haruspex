require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'haruspex/haruspex'

describe Haruspex::Haruspex do
  
  before(:each) do
    @player = Haruspex::Haruspex.new
  end

  it "should be instantiable with no paramters" do
    lambda { Haruspex::Haruspex.new }.should_not raise_error
  end
  
  it "should guess the letter which occurs in the most different words" do
    @player.word_list=["bal","bxq","bac"]

    @player.new_game(6)    
    @player.guess("___", 6).should == 'b'
  end
  
  it "should guess the next most common letter if the first guess is wrong" do
    @player.word_list=["bal","bxq","bac"]

    @player.new_game(6)
    @player.guess("___", 6).should == 'b'
    @player.guess("___", 5).should == 'a'
  end
  
  it "should partition by size" do 
    @player.word_list=["bal","bxq","bac", "aa", "ab"]

    @player.new_game(6)
    @player.guess("___", 6).should == 'b'
    @player.guess("___", 5).should == 'a'
  end
  
  it "should refresh the dictionary after every game" do
    @player.word_list=["bal","bxq","bac", "aa", "ab"]

    @player.new_game(6)
    @player.guess("___", 6).should == 'b'

    @player.new_game(6)
    @player.guess("__", 6).should == 'a'
  end
  
  it "should remove words containing incorrect letters" do
    @player.word_list=["bal","bxq","bac", "gsn", "gtd", "arb"]

    @player.new_game(6)
    @player.guess("___", 6).should == 'b'
    @player.incorrect_guess('b')
    @player.guess("___", 5).should == 'g'
  end
  
  it "should remove words not containing correct letters" do
    @player.word_list=["aaa", "bac", "btr", "tub"]

    @player.new_game(6)
    @player.guess("___", 6).should == 'b'
    @player.correct_guess('b')
    @player.guess("___", 5).should == 't'
  end
  
  it "should match patterns after a successful guess" do
    @player.word_list=["bnt", "ntk", "btr", "tub", "ltr"]

    @player.new_game(6)
    @player.guess("___", 6).should == 't'
    @player.correct_guess('t')
    @player.guess("_t_", 5).should == 'r'
  end
  
  # it "should win all 10k games" do
  #   wins = 0
  #   possible_words = load_words
  #   unguessed = loss_words
  #   @player.word_list = possible_words
  #   possible_words.each_with_index do |test_word, index|
  #     turns = 6
  #     correct_letters = []
  #     @player.new_game(turns)
  #     while (filter(test_word, correct_letters) != test_word ) && turns > 0
  #       guess = @player.guess(filter(test_word, correct_letters), turns)
  #       if test_word.include? guess then
  #         correct_letters << guess
  #         @player.correct_guess(guess)
  #       else
  #         @player.incorrect_guess(guess)
  #         turns -= 1
  #       end
  #       p "guess: #{guess} => #{filter(test_word, correct_letters)} <br/>"
  #     end
  #     if filter(test_word, correct_letters) == test_word  then
  #       wins += 1
  #       # p "win : #{test_word}"
  #     else
  #       p "loss : #{test_word}"
  #     end
  #     p "record :: #{wins} / #{index}"
  #   end
  # end
  # 
  # def filter word, correct_letters
  #   filtered_word = ""
  #   for letter_index in 0..word.size - 1 do
  #     letter = word[letter_index, 1]
  #     filtered_word << (correct_letters.include?(letter) ? letter : "_" )
  #   end
  #   return filtered_word
  # end
  # 
  # def load_words
  #   words = []
  #   File.open File.dirname(__FILE__) + '/words', 'r' do |file|
  #     file.each { |line| words << line.chomp.downcase }
  #   end
  #   return words
  # end
  # 
  # def loss_words
  #   words = []
  #   File.open File.dirname(__FILE__) + '/losses', 'r' do |file|
  #     file.each { |line| words << line.chomp.downcase }
  #   end
  #   return words
  # end

end