require 'sphinx_helper'

feature 'User can search for users', %q{
  As an Anyone user
  I'd like to be able to search for the user
  In order to find needed user  
} do

  given!(:user) { create :user, email: 'my@uniq.email' }
  given!(:users) { create_list :user, 2 }

  background { visit root_path }

  scenario 'Searches for the users', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'uniq'
      click_on 'Find'

      expect(page).to have_content user.email
      expect(page).to_not have_content users.first.email
      expect(page).to_not have_content users.last.email
    end
  end
end
