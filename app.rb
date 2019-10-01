require 'sinatra/base'
require 'logger'
require 'erb'
require './models/idea.rb'


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

get '/user_profile/watched' do
  ungroupedFilms = [{
    image:"https://contentserver.com.au/assets/598411_p173378_p_v8_au.jpg",
    title: "The Dark Knight",
    year: "2008",
    synopsis: "With the help of allies Lt. Jim Gordon (Gary Oldman) and DA Harvey Dent (Aaron Eckhart), Batman (Christian Bale) has been able to keep a tight lid on crime in Gotham City. But when a vile young criminal calling himself the Joker (Heath Ledger) suddenly throws the town into chaos, the caped Crusader …"
  },
  {
    image:"https://contentserver.com.au/assets/598411_p173378_p_v8_au.jpg",
    title: "The Dark Knight",
    year: "2008",
    synopsis: "With the help of allies Lt. Jim Gordon (Gary Oldman) and DA Harvey Dent (Aaron Eckhart), Batman (Christian Bale) has been able to keep a tight lid on crime in Gotham City. But when a vile young criminal calling himself the Joker (Heath Ledger) suddenly throws the town into chaos, the caped Crusader …"
  },
  {
    image:"https://contentserver.com.au/assets/598411_p173378_p_v8_au.jpg",
    title: "The Dark Knight",
    year: "2008",
    synopsis: "With the help of allies Lt. Jim Gordon (Gary Oldman) and DA Harvey Dent (Aaron Eckhart), Batman (Christian Bale) has been able to keep a tight lid on crime in Gotham City. But when a vile young criminal calling himself the Joker (Heath Ledger) suddenly throws the town into chaos, the caped Crusader …"
  },
  {
    image:"https://contentserver.com.au/assets/598411_p173378_p_v8_au.jpg",
    title: "The Dark Knight",
    year: "2008",
    synopsis: "With the help of allies Lt. Jim Gordon (Gary Oldman) and DA Harvey Dent (Aaron Eckhart), Batman (Christian Bale) has been able to keep a tight lid on crime in Gotham City. But when a vile young criminal calling himself the Joker (Heath Ledger) suddenly throws the town into chaos, the caped Crusader …"
  }]
  @films = ungroupedFilms.each_slice(3).to_a
  erb :_watched
end

end
