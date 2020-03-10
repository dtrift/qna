require 'sphinx_helper'

feature 'User can search for users', %q{
  As an Anyone user
  I'd like to be able to search for the user
  In order to find needed user  
} do

  given(:question) { create :question, body: 'Uniq body for the Question' }
  given(:answer) { create :answer, body: 'Uniq body for the Answer' }
  given!(:user) { create :user, email: 'my@uniq.email' }
  given(:users) { create_list :user, 2 }

  given(:search_query) { 
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'uniq'
      select 'User', from: :resource
      click_on 'Find'
    end 
  }

  describe 'Searches for the users', sphinx: true, js: true do
    background do
      visit root_path
      search_query
    end

    scenario 'the user is in the results' do
      expect(page).to have_content user.email
    end

    scenario 'other user are not present in the results' do
      expect(page).to_not have_content users.first.email
      expect(page).to_not have_content users.last.email
    end

    scenario 'other entities are not present in the results' do
      expect(page).to_not have_content question.body
      expect(page).to_not have_content answer.body
    end
  end
end
