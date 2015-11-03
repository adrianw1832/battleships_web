require 'spec_helper'
require_relative 'helper'

feature 'Playing single player' do
  scenario 'Board should have a randomly placed ship' do
    singleplayer
    expect($game.player_2).to receive(:place_random_vertical_ship)
    click_button('Start Game')
  end

  scenario 'Board should have a randomly placed ship' do
    singleplayer
    expect($game.player_2).to receive(:place_random_horizontal_ship)
    click_button('Start Game')
  end

  scenario 'Player can fire at the board' do
    singleplayer
    place_one_ship('A1')
    click_button('Start Game')
    expect(page).to have_button('Fire')
  end

  scenario 'Player can see the hit on the board' do
    singleplayer
    allow($game.player_2).to receive(:place_random_vertical_ship) { $game.player_2.place_ship(Ship.submarine, :A1) }
    click_button('Start Game')
    fill_in('coordinate', with: 'A1')
    click_button('Fire')
    expect(page).to have_content(
    'ABCDEFGHIJ
  ------------
 1|*         |1
 2|          |2
 3|          |3
 4|          |4
 5|          |5
 6|          |6
 7|          |7
 8|          |8
 9|          |9
10|          |10
  ------------
   ABCDEFGHIJ')
    end

  scenario 'Player can see the miss on the board' do
    singleplayer
    allow($game.player_2).to receive(:place_random_vertical_ship) { $game.player_2.place_ship(Ship.submarine, :A1) }
    click_button('Start Game')
    fill_in('coordinate', with: 'A3')
    click_button('Fire')
    expect(page).to have_content(
    'ABCDEFGHIJ
  ------------
 1|          |1
 2|          |2
 3|-         |3
 4|          |4
 5|          |5
 6|          |6
 7|          |7
 8|          |8
 9|          |9
10|          |10
  ------------
   ABCDEFGHIJ')
  end

  scenario 'Computer randomly fires back at the player' do
    singleplayer
    place_one_ship('A1')
    click_button('Start Game')
    fill_in('coordinate', with: 'A1')
    allow($game.player_2).to receive(:random_shoot) { $game.player_2.shoot(:A3) }
    click_button('Fire')
    expect(page).to have_content(
    'ABCDEFGHIJ
  ------------
 1|D         |1
 2|D         |2
 3|-         |3
 4|          |4
 5|          |5
 6|          |6
 7|          |7
 8|          |8
 9|          |9
10|          |10
  ------------
   ABCDEFGHIJ')
  end

  scenario 'it goes to results page when game is finished' do
    singleplayer
    place_one_ship('A1')
    allow($game.player_2).to receive(:place_random_vertical_ship) { $game.player_2.place_ship(Ship.submarine, :A1) }
    allow($game.player_2).to receive(:place_random_horizontal_ship) { $game.player_2.place_ship(Ship.submarine, :E6) }
    click_button('Start Game')
    fill_in('coordinate', with: 'A1')
    click_button('Fire')
    fill_in('coordinate', with: 'E6')
    click_button('Fire')
    expect(current_path).to eq '/results'
  end

  scenario 'it says player 1 wins when player 1 wins' do
    singleplayer
    place_one_ship('A1')
    allow($game.player_2).to receive(:place_random_vertical_ship) { $game.player_2.place_ship(Ship.submarine, :A1) }
    allow($game.player_2).to receive(:place_random_horizontal_ship) { $game.player_2.place_ship(Ship.submarine, :E6) }
    click_button('Start Game')
    fill_in('coordinate', with: 'A1')
    click_button('Fire')
    fill_in('coordinate', with: 'E6')
    click_button('Fire')
    expect(page).to have_content 'You have won!'
  end

  xscenario 'it says player 1 loses when player 1 loses' do
    singleplayer
    place_one_ship('A1')
    click_button('Start Game')
    fill_in('coordinate', with: 'A1')
    allow($game.player_2).to receive(:random_shoot) { $game.player_2.shoot(:A1) }
    click_button('Fire')
    expect(page).to have_content 'You have lost!'
  end
end
