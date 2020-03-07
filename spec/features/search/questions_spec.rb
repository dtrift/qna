require 'sphinx_helper'

feature 'User can search for question', %q{
  As an Anyone user
  I'd like to be able to search for the question
  In order to find needed question  
} do

  given!(:question) { create :question, title: 'Question Title', body: 'Some Body for the Question' }

  background { visit questions_path }

  scenario 'User searches for the question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'some body'
      click_on 'Find'

      expect(page).to have_content question.body
    end
  end
end
