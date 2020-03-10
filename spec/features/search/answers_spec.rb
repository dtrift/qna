require 'sphinx_helper'

feature 'User can search for the answer', %q{
  As an Anyone user
  I'd like to be able to search for the answer
  In order to find needed answer  
} do

  given(:question) { create :question, body: 'Some Body content for the question' }
  given(:answers) { create_list :answer, 2 }
  given!(:answer) { create :answer, body: 'Some Body content for the answer' }

  given(:search_query) { 
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'some body'
      select 'Answer', from: :resource
      click_on 'Find'
    end 
  }

  describe 'Searches for the answers', sphinx: true, js: true do
    background do
      visit root_path
      search_query
    end

    scenario 'the answer is in the results' do
      expect(page).to have_content answer.body 
    end

    scenario 'other answers are not present in the results' do
      expect(page).to_not have_content answers.first.body
      expect(page).to_not have_content answers.last.body
    end

    scenario 'other entities are not present in the results' do
      expect(page).to_not have_content question.body
    end
  end
end
