require 'sphinx_helper'

feature 'User can search for question', %q{
  As an Anyone user
  I'd like to be able to search for the question
  In order to find needed question  
} do

  given(:answer) { create :answer, body: 'Some body for the Answer' }
  given(:questions) { create_list :question, 2 }
  given!(:question) { create :question, title: 'SOME BODY Title', body: 'Body for the question' }

  given(:search_query) { 
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'some body'
      select 'Question', from: :resource
      click_on 'Find'
    end 
  }

  describe 'Searches for the question', sphinx: true, js: true do
    background do
      visit root_path
      search_query
    end

    scenario 'the question is in the results' do
      expect(page).to have_content question.body 
    end

    scenario 'other question are not present in the results' do
      expect(page).to_not have_content questions.first.body
      expect(page).to_not have_content questions.last.body
    end

    scenario 'other entities are not present in the results' do
      expect(page).to_not have_content answer.body
    end
  end
end
