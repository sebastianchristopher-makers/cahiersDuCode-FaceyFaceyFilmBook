require 'sinatra/base'
require 'logger'
require 'erb'
require 'dotenv/load'
require 'rack'
require 'pg'
require 'uri'
require 'net/http'
require 'json'
require_relative './lib/user'
require_relative './lib/database_connection'
require_relative './lib/film.rb'
require_relative './lib/recommendation.rb'
require_relative './lib/showtime.rb'
require_relative './lib/cinema.rb'

class App < Sinatra::Base
  set :sessions, true
  set :logging, true
  set :partial_template_engine, :erb
  if (ENV["DATABASE_URL"])
    dbUri = URI.parse(ENV["DATABASE_URL"])
  else
    dbUri = URI.parse("postgres://localhost:5432/filmbook_test")
  end
  # PG.connect(dbUri.hostname, dbUri.port, nil, nil, dbUri.path[1..-1], dbUri.user, dbUri.password)
  DatabaseConnection.setup(dbUri)

  before do
    @user = session[:user]
  end

  not_found do
    erb :error
  end

  get '/' do
    erb :index
  end

  get '/users/new' do
    erb :sign_up
  end

  get '/sessions/new' do
    erb :sign_in
  end

  get '/user-exists' do
    if User.user_exists?(params[:email])
      status 401
      body "User already exists!"
    end
  end

  post '/users/new' do
    email = params[:inputEmail]
    password = params[:inputPassword]

    user = User.create(email, password)
    session[:user] = user
    redirect '/search'
  end

  post '/sessions/new' do
    email = params[:inputEmail]
    password = params[:inputPassword]
    user = User.authenticate(email, password)
    if user
      session[:user] = user
      redirect "#{user.id}/user_profile"
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
    @key = ENV['API_KEY']
    erb :search
  end

  post '/search' do
    if session[:user] != nil
      user_id = session[:user].id
      film_id = params[:id]
      title = params[:title]
      poster_path = params[:poster_path]
      year = params[:year].to_i
      watched = params[:watched]
      to_watch = params[:to_watch]
      url = "https://api.internationalshowtimes.com/v4/movies?apikey=" + ENV['SHOWTIMES_API'] + "&tmdb_id=" + film_id
      uri = URI(url)
      response = JSON.parse(Net::HTTP.get(uri))
      showtime_id = response["movies"][0]["id"]
      Film.create(film_id, title, poster_path, year, showtime_id) unless Film.film_exists?(film_id)
      Film.add(user_id, film_id, watched, to_watch)
    else
      status 403
      body 'Forbidden; only logged in users can add a film'
    end
  end

  get '/search-api' do
    url = 'https://api.themoviedb.org/3/search/movie?api_key=' + ENV['API_KEY'] + '&language=en-US&query=' + params[:filmToSearch] + '&page=1&include_adult=false'
    uri = URI(url)
    response = Net::HTTP.get(uri)
  end

  get '/:id/user_profile/to-watch' do
    userId = params[:id]
    @films = Film.find_to_watch(userId).each_slice(3).to_a
    erb :_to_watch
  end

  get '/:id/user_profile/watched' do
    userId = params[:id]
    @films = Film.find_watched(userId).each_slice(3).to_a
    erb :_watched
  end

  get '/:id/user_profile' do
    userId = params[:id]
    @id = userId
    @films = Film.find_by_user_id(userId).each_slice(3).to_a
    @email = User.find_by_id(userId).email
    erb :user_profile
  end

  get '/:id/dashboard' do

    erb :dashboard
  end

  get '/films/:id' do
    film_id = params[:id]
    url = 'https://api.themoviedb.org/3/movie/' + film_id + '/videos?api_key=' + ENV['API_KEY'] + '&language=en-US'
    uri = URI(url)
    response = JSON.parse(Net::HTTP.get(uri))
    @film = Film.find_by_id(film_id)
    @title = Film.find_by_id(film_id).title
    @src = "https://www.youtube.com/embed/#{response["results"][0]["key"]}" if response["results"].size > 0

    url = 'https://api.themoviedb.org/3/movie/' + film_id + '/recommendations?api_key=' + ENV['API_KEY'] + '&language=en-US&page=1'
    uri = URI(url)
    response = JSON.parse(Net::HTTP.get(uri))
    @recommendations = response["results"].map{ |result|
      Recommendation.new(result["id"], result["original_title"], result["poster_path"])
    }

    url = "https://api.internationalshowtimes.com/v4/showtimes?apikey=" + ENV['SHOWTIMES_API'] + "&movie_id=" + @film.showtime_id.to_s + "&location=51.515724,-0.065091&distance=30"
    uri = URI(url)
    response = JSON.parse(Net::HTTP.get(uri))
    @showtimes = response["showtimes"].map{ |showtime|
      cinema_id = showtime["cinema_id"]
      unless Cinema.cinema_exists?(cinema_id)
        url = "https://api.internationalshowtimes.com/v4/cinemas/" + cinema_id + "?apikey=" + ENV["SHOWTIMES_API"]
        uri = URI(url)
        response = JSON.parse(Net::HTTP.get(uri))
        Cinema.create(response["cinema"]["id"], response["cinema"]["name"], response["cinema"]["website"], response["cinema"]["location"]["address"]["city"], response["cinema"]["location"]["address"]["zipcode"])
      end
      cinema = Cinema.find_by_cinema_id(cinema_id)
      Showtime.create(showtime, cinema)
    }

    erb :_film
  end

  run! if app_file == $PROGRAM_NAME

end
