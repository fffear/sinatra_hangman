$: << File.expand_path("../lib", __FILE__)

require 'sinatra'
require 'sinatra/reloader' if development?
require 'hangman'

configure do
  enable :sessions
end

get '/' do
  erb :index
end

post '/' do
  session[:hangman] = Hangman.new
  redirect to('/game')
end

get '/game' do
  erb :round, :locals => {:secret_word => session[:hangman].secret_word,
                          :guesses_remaining => session[:hangman].guesses_remaining,
                          :encrypted_word => session[:hangman].encrypted_word.join(" "),
                          :incorrect_letters => session[:hangman].incorrect_letters}
end

post '/game' do
  guessed_letter = params['guessed_letter']
  session[:hangman].check_guess(guessed_letter)
  session[:hangman].find_and_update_position_of_encrypted_word(guessed_letter)
  erb :round, :locals => {:secret_word => session[:hangman].secret_word,
                          :guesses_remaining => session[:hangman].guesses_remaining,
                          :guessed_letter => guessed_letter,
                          :encrypted_word => session[:hangman].encrypted_word.join(" "),
                          :incorrect_letters => session[:hangman].incorrect_letters}
end