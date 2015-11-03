require 'spec_helper'
require_relative 'helper'

feature 'Starting a new multiplayer game' do
  scenario 'Starting a new multiplayer game' do
    visit '/'
    fill_in('name', with: 'Adrian')
    click_button('Submit')
    expect(page).to have_button('Multiplayer Mode')
  end

  scenario 'Goes to lobby after entering the name' do
    multiplayer
    expect(current_path).to eq '/lobby'
  end

  scenario 'Waits in the lobby until the opponent joins' do
    multiplayer
    expect(page).to have_content 'Waiting...'
  end

  xscenario 'Waits in the lobby until the opponent joins' do
    browser(:one) do
      multiplayer
    end

    browser(:two) do
      visit '/'
      fill_in('name', with: 'Bob')
      click_button('Submit')
      click_button 'Multiplayer Mode'
      expect(current_path).to eq '/new_board3'
    end
  end

  xscenario 'first player goes to board after the opponent joins' do
    browser(:one) do
      visit '/'
      fill_in('name', with: 'Adrian')
      click_button('Submit')
      click_button 'Multiplayer Mode'
    end

    browser(:two) do
      visit '/'
      fill_in('name', with: 'Bob')
      click_button('Submit')
      click_button 'Multiplayer Mode'
    end

    browser(:one) do
      expect(current_path).to eq '/new_board3'
    end
  end

  scenario 'player can place ships' do
    browser(:one) do
      visit '/'
      fill_in('name', with: 'Adrian')
      click_button('Submit')
      click_button 'Multiplayer Mode'
    end

    browser(:two) do
      visit '/'
      fill_in('name', with: 'Bob')
      click_button('Submit')
      click_button 'Multiplayer Mode'
    end

    browser(:one) do
      place_all_ships
      click_button('Start Game')
      expect(current_path).to eq '/gameplay'
    end
  end
end
