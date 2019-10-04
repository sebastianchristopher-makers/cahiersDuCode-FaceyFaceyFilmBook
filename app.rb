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
    @key = ENV['API_KEY']
    erb :search
  end

  post '/search' do
    if session[:user] != nil
      user_id = session[:user].id
      film_id = params[:id]
      title = params[:title]
      poster_path = params[:poster_path]
      year = params[:year]
      Film.create(film_id, title, poster_path, year)
      Film.add(user_id, film_id)
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

  get '/user_profile/watched' do
    if session[:user]
      userId = session[:user].id
      @films = Film.find_by_user_id(userId).each_slice(3).to_a
    else
      @films= nil
    end
    erb :_watched
  end

  run! if app_file == $PROGRAM_NAME

end
