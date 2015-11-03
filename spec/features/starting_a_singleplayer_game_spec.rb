require 'spec_helper'
require_relative 'helper'

feature 'Starting a new single player game' do
  scenario 'Give you a form to fill in your name' do
    visit '/'
    expect(page).to have_content "What's your name?"
  end

  scenario 'Takes you to menu after entering your name' do
    visit '/'
    fill_in('name', with: 'Adrian')
    click_button('Submit')
    click_button('Single Player')
    expect(page).to have_content "Let's place your battleships, Adrian!"
  end

  scenario 'Stays on the same page if you do not fill in your name' do
    visit '/'
    fill_in('name', with: '')
    click_button('Submit')
    expect(current_path).to eq '/'
  end

  scenario 'Player gets a new board after they press singleplayer' do
    singleplayer
    expect(page).to have_content(
    'ABCDEFGHIJ
  ------------
 1|          |1
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

  scenario 'Player can place a ship on the board' do
    singleplayer
    place_one_ship('A1')
    expect(page).to have_content(
    'ABCDEFGHIJ
  ------------
 1|D         |1
 2|D         |2
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
end
