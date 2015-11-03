require 'sinatra/base'
require 'shotgun'
require_relative './battleships'

class BattleshipWeb < Sinatra::Base
  enable :sessions
  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    p session
    erb :index, layout: false
  end

  post '/' do
    $all_sessions = []
    session[:name] = params[:name]
    erb :index, layout: false
    redirect '/mode' unless session[:name].empty?
  end

  get '/mode' do
    erb :mode
  end

  post '/mode' do
    session[:mode] = params[:mode]
    redirect '/new_board' if session[:mode] == 'singleplayer'
    redirect '/name' if session[:mode] == 'local_2_player'
    redirect '/lobby' if session[:mode] == 'multiplayer'
    erb :mode
  end

  get '/lobby' do
    id = session[:session_id]
    $all_sessions << id unless $all_sessions.include?(id)
    redirect '/new_board3' if $all_sessions.length.even?
    erb :lobby
  end

  get '/lobby2' do
    if $ready == 2
      redirect '/multi_gameplay2'
    end
    erb :lobby2
  end

  post '/lobby2' do
    $ready += 1
    erb :lobby2
  end

  get '/name' do
    erb :name
  end

  post '/name' do
    session[:name2] = params[:name]
    erb :name
    redirect '/new_board' unless session[:name2].empty?
  end

  # get '/new_game' do
  #   erb :new_game
  # end

  # post '/new_game' do
  #   condition = session[:mode] == 'singleplayer' ? false : session[:name2].empty?
  #   redirect '/new_game' if session[:name].empty? || condition
  #   redirect '/new_board' if session[:mode] == 'singleplayer'
  #   redirect '/new_board' unless session[:name].empty? || session[:name2].empty?
  # end

  get '/new_board' do
    $game = Game.new(Player, Board)
    erb :new_board
  end

  post '/new_board' do
    @ship = params[:ship]
    @coordinate = params[:coordinate]
    @direction = params[:direction]
    $game.player_1.place_ship(Ship.new(@ship), @coordinate.to_sym, @direction.to_sym)
    erb :new_board
  end

  get '/new_board2' do
    session[:turn] = 'player_1'
    erb :new_board2
  end

  post '/new_board2' do
    @ship = params[:ship]
    @coordinate = params[:coordinate]
    @direction = params[:direction]
    $game.player_2.place_ship(Ship.new(@ship), @coordinate.to_sym, @direction.to_sym)
    erb :new_board2
  end

  get '/new_board3' do
    $ready = 0
    $hits = 0
    $game = Game.new(Player, Board)
    erb :new_board3
  end

  post '/new_board3' do
    @ship = params[:ship]
    @coordinate = params[:coordinate]
    @direction = params[:direction]
    if player_1_go
      $game.player_1.place_ship(Ship.new(@ship), @coordinate.to_sym, @direction.to_sym)
    else
      $game.player_2.place_ship(Ship.new(@ship), @coordinate.to_sym, @direction.to_sym)
    end
    erb :new_board3
  end

  get '/gameplay' do
    $game.player_2.place_random_vertical_ship
    $game.player_2.place_random_horizontal_ship
    erb :gameplay
  end

  post '/gameplay' do
    @coordinate = params[:coordinate]
    $game.player_1.shoot(@coordinate.to_sym)
    $game.player_2.random_shoot
    redirect '/results' if $game.has_winner?
    erb :gameplay
  end

  get '/multi_gameplay' do
    erb :multi_gameplay
  end

  post '/multi_gameplay' do
    @coordinate = params[:coordinate]
    session[:turn] == 'player_1' ? $game.player_1.shoot(@coordinate.to_sym) : $game.player_2.shoot(@coordinate.to_sym)
    redirect '/results' if $game.has_winner?
    erb :multi_gameplay
  end

  get '/multi_gameplay2' do
    redirect '/results2' if $game.has_winner?
    erb :multi_gameplay2
  end

  post '/multi_gameplay2' do
    @coordinate = params[:coordinate]
    if $hits.even?
      $game.player_1.shoot(@coordinate.to_sym)
      $hits += 1
    else
      $game.player_2.shoot(@coordinate.to_sym)
      $hits += 1
    end
    redirect '/results2' if $game.has_winner?
    erb :multi_gameplay2
  end

  get '/switch' do
    session[:turn] = (session[:turn] == 'player_1' ? 'player_2' : 'player_1')
    redirect '/multi_gameplay'
  end

  get '/results' do
    erb :results
  end

  get '/results2' do
    erb :results2
  end

  def player_1_go
    $all_sessions.index(session[:session_id]).even?
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
