require 'sinatra/base'
require 'logger'
require 'erb'
require 'dotenv/load'
require 'rack'

class App < Sinatra::Base
  set :sessions, true
  set :logging, true
  set :partial_template_engine, :erb

  not_found do
    erb :error
  end

  get '/' do
    erb :index
  end

  get '/user_profile' do
    erb :user_profile
  end

  get '/search' do
    # session[:films] = [{
    #   poster_path:"qJ2tW6WMUDux911r6m7haRef0WH.jpg",
    #   title: "The Dark Knight",
    #   year: "2008",
    #   synopsis: "With the help of allies Lt. Jim Gordon (Gary Oldman) and DA Harvey Dent (Aaron Eckhart), Batman (Christian Bale) has been able to keep a tight lid on crime in Gotham City. But when a vile young criminal calling himself the Joker (Heath Ledger) suddenly throws the town into chaos, the caped Crusader …"
    # },
    # {
    #   poster_path:"awQpBhnxmbDK7br3RqajtNATrUL.jpg",
    #   title: "Return to Oz",
    #   year: "1985",
    #   synopsis: "Dorothy, saved from a psychiatric experiment by a mysterious girl, finds herself back in the land of her dreams, and makes delightful new friends, and dangerous new enemies. …"
    # },
    # {
    #   poster_path:"2VtsJoxvjpcMpwh0gweS8IMfHxO.jpg",
    #   title: "The Awful Truth",
    #   year: "1937",
    #   synopsis: "Unfounded suspicions lead a married couple to begin divorce proceedings, whereupon they start undermining each other's attempts to find new romance …"
    # },
    # {
    #   poster_path:"vmRWSLP1DE9WTta0hfzIafJ0dID.jpg",
    #   title: "Ivan's Childhood",
    #   year: "1962",
    #   synopsis: "Poetic journey through the shards and shadows of one boy's war-ravaged youth. …"
    # },
    # {
    #   poster_path:"aUC39cFC2KO8CJ0EV0ijIJRr3PT.jpg",
    #   title: "The Room",
    #   year: "2003",
    #   synopsis: "YOU'RE TEARING ME APART, LISA! …"
    # }]
    @key = ENV['API_KEY']
    erb :search
  end

  post '/search' do
    session[:films] = [] if !session[:films]
    session[:films] << {poster_path: params[:poster_path],title: params[:title],year: params[:year]}
    puts
  end

  get '/user_profile/watched' do
    @films = session[:films].each_slice(3).to_a
    erb :_watched
  end

end
