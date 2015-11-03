require 'spec_helper'
require_relative 'helper'

feature 'Starting a new local 2 player game' do
  scenario "Gives you the chance to fill in yours and opponent's name" do
    local_multiplayer
    fill_in('name', with: 'Bob')
    click_button('Submit')
    expect(page).to have_content "Let's place your battleships, Adrian!"
  end

  scenario 'Stays on the same page if opponent name is not entered' do
    local_multiplayer
    fill_in('name', with: '')
    click_button('Submit')
    expect(current_path).to eq '/name'
  end

  scenario 'Your opponent gets to place ships after you have' do
    local_multiplayer
    fill_in('name', with: 'Bob')
    click_button('Submit')
    place_one_ship('A1')
    click_button("Opponent's turn")
    expect(page).to have_content "Let's place your battleships, Bob!"
  end
end
