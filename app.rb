require 'sinatra/base'
require 'logger'
require 'erb'
require 'dotenv/load'
require 'rack'
require 'pg'
require 'uri'
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
    filmId = params[:id]
    if session[:user] != nil
      userId = session[:user].id
      Film.add(userId, filmId)
    else
      puts "You must be logged in"
    end
  end

  get '/user_profile/watched' do
    userId = session[:user].id
    @films = Film.all(userId)
    @films = session[:films].each_slice(3).to_a
    erb :_watched
  end

  run! if app_file == $PROGRAM_NAME

end
