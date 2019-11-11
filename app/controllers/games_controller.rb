require 'net/https'
require 'json'

class GamesController < ActionController::Base
  API_URL = "https://wagon-dictionary.herokuapp.com/"

  def new
    alphabet = ('a'..'z').to_a
    @letters = alphabet.sample(10)
  end

  def score
    word = params["word"]
    letters = params["letters"].split(',')
    # On créé un tableau avec toutes les lettres du mot
    word_letters = word.chars # pareil que params["word"].split('')
    # On soustrait au tableau des lettres du mot les lettres tirrées au hasard
    # Si le tableau résultat est vide, le mon ne contient que des lettres de la liste de celles tirées aus hasard.
    invalid_letters_in_word = word_letters - letters

    if invalid_letters_in_word.length == 0
      # Vérifier que le mot et valide
      url = API_URL + word
      request_result = Net::HTTP.get(URI(url))
      api_result = JSON.parse(request_result)

      if api_result["found"] == false
        @score = "The word is valid according to the grid, but is not a valid English word"
      else
        @score = "The word is valid according to the grid, and is a valid English word"
      end
    else
      @score = "The word can’t be built out of the original grid"
    end
  end
end

