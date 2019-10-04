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

  get '/:id/user_profile/to-watch' do
    userId = params[:id]
    @films = Film.find_by_user_id(userId).each_slice(3).to_a
    erb :_to_watch
  end

  get '/:id/user_profile/watched' do
    userId = params[:id]
    @films = Film.find_by_user_id(userId).each_slice(3).to_a
    erb :_watched
  end

  # get '/user_profile/watched' do
  #   if session[:user]
  #     userId = session[:user].id
  #     @films = Film.find_by_user_id(userId).each_slice(3).to_a
  #   else
  #     @films= nil
  #   end
  # end

  get '/:id/user_profile' do
    userId = params[:id]
    @id = userId
    p @id
    @films = Film.find_by_user_id(userId).each_slice(3).to_a
    erb :user_profile
  end

  run! if app_file == $PROGRAM_NAME

end
