require 'sphinx_helper'

feature 'User can search for question', %q{
  As an Anyone user
  I'd like to be able to search for the question
  In order to find needed question  
} do

  given(:questions) { create_list :question, 2 }
  given!(:question1) { create :question, title: 'SOME BODY Title', body: 'Body for the Question1' }
  given!(:question2) { create :question, title: 'Question Title', body: 'Some Body content for the Question2' }

  background { visit questions_path }

  scenario 'Searches for the question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'some body'
      click_on 'Find'

      expect(page).to have_content question1.title
      expect(page).to have_content question2.title
      expect(page).to_not have_content questions.first.title
      expect(page).to_not have_content questions.last.title
    end
  end
end
