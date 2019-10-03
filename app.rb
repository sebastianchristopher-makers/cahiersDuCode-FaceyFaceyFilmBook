require 'sinatra/base'
require 'logger'
require 'erb'
require 'dotenv/load'
require 'rack'
require 'pg'
require_relative './lib/user'
require_relative './lib/database_connection'

class App < Sinatra::Base
  set :sessions, true
  set :logging, true
  set :partial_template_engine, :erb
  DatabaseConnection.setup("filmbook_test")

  not_found do
    erb :error
  end

  get '/' do
    erb :index
  end

  get '/user_profile' do
    @user = session[:user]
    p @user
    erb :user_profile
  end

  get '/users/new' do
    erb :sign_up
  end

  get '/sessions/new' do
    erb :sign_in
  end

  post '/users/new' do
    email = params[:inputEmail]
    password = params[:inputPassword]
    user = User.create(email, password)
    session[:user] = user
    redirect '/user_profile'
  end

  post '/sessions/new' do
    email = params[:inputEmail]
    password = params[:inputPassword]
    user = User.authenticate(email, password)
    if user
      session[:user] = user
      redirect '/user_profile'
    else
      puts("Wrong Username And/or Password")
      redirect '/sessions/new'
    end
  end

  post '/sessions/destroy' do
    session.clear
    redirect '/sessions/new'
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

  run! if app_file == $PROGRAM_NAME

end
