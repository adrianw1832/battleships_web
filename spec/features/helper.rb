def singleplayer
  visit '/'
  fill_in('name', with: 'Adrian')
  click_button('Submit')
  click_button('Single Player Mode')
end

def local_multiplayer
  visit '/'
  fill_in('name', with: 'Adrian')
  click_button('Submit')
  click_button('Local 2 Player Mode')
end

def multiplayer
  visit '/'
  fill_in('name', with: 'Adrian')
  click_button('Submit')
  click_button('Multiplayer Mode')
end

def browser(name)
  old_session = Capybara.session_name
  Capybara.session_name = name
  yield
  Capybara.session_name = old_session
end

def place_one_ship(coord)
  coordinate = coord
  fill_in('coordinate', with: coordinate)
  select('Destroyer', from: 'ship')
  choose('Vertically')
  click_button('Place Ship')
end

def place_all_ships
  fill_in('coordinate', with: 'A1')
  select('Submarine', from: 'ship')
  choose('Vertically')
  click_button('Place Ship')
  fill_in('coordinate', with: 'B1')
  select('Submarine', from: 'ship')
  choose('Vertically')
  click_button('Place Ship')
  fill_in('coordinate', with: 'C1')
  select('Submarine', from: 'ship')
  choose('Vertically')
  click_button('Place Ship')
  fill_in('coordinate', with: 'D1')
  select('Submarine', from: 'ship')
  choose('Vertically')
  click_button('Place Ship')
  fill_in('coordinate', with: 'E1')
  select('Submarine', from: 'ship')
  choose('Vertically')
  click_button('Place Ship')
end
