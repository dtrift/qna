require 'sphinx_helper'

feature 'User can search for answer', %q{
  As an Anyone user
  I'd like to be able to search for the answer
  In order to find needed answer  
} do

  given(:answers) { create_list :answer, 2 }
  given!(:answer) { create :answer, body: 'Some Body content for the answer2' }

  background { visit root_path }

  scenario 'Searches for the answers', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'some body'
      click_on 'Find'

      expect(page).to have_content answer.body
      expect(page).to_not have_content answers.first.body
      expect(page).to_not have_content answers.last.body
    end
  end
end
