class Hangman
  attr_accessor :secret_word, :encrypted_word, :incorrect_letters, :guesses_remaining

  def initialize
    @secret_word = generate_secret_word
    @encrypted_word = encrypt_guessed_word(@secret_word)
    @incorrect_letters = []
    @guesses_remaining = 6
  end

  def generate_secret_word
    dictionary = File.open("5desk.txt", "r") { |f| f.read }
    dictionary = dictionary.split("\r\n")
                           .select! { |word| word.length >= 5 && !(/[A-Z]/ =~ word) }
    dictionary[rand(dictionary.length - 1)].downcase
  end
  
  def encrypt_guessed_word(word)
    word.split("").map { |letter| "_" }
  end
  
  def check_guess(guessed_letter)
    if !secret_word.include?(guessed_letter) && !incorrect_letters.include?(guessed_letter)
      decrement_guesses_remaining
      incorrect_letters << guessed_letter
    end
  end
  
  def find_and_update_position_of_encrypted_word(guessed_letter)
    index_of_correct_guess = secret_word.split("").each_index.select { |i| secret_word[i] == guessed_letter }
    index_of_correct_guess.each { |n| encrypted_word[n] = guessed_letter }
  end

  def decrement_guesses_remaining
    @guesses_remaining -= 1
  end
end