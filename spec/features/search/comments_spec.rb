require 'sphinx_helper'

feature 'User can search for comment', %q{
  As an Anyone user
  I'd like to be able to search for the comment
  In order to find needed comment  
} do

  given(:commentable_question) { create :question }
  given(:question) { create :question, title: 'Test Content for the Quetion' }
  given(:comments) { create_list :comment, 2, commentable: commentable_question }

  given!(:comment) {
    create :comment,
    commentable: question,
    content: 'Test Content for the comment1'
  }

  given(:search_query) { 
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'test content'
      select 'Comment', from: :resource
      click_on 'Find'
    end 
  }


  describe 'Searches for the comments', sphinx: true, js: true do
    background do
      visit root_path
      search_query
    end

    scenario 'the comment is in the results' do
      expect(page).to have_content comment.content
    end

    scenario 'other comments are not present in the results' do
      expect(page).to_not have_content comments.first.content
      expect(page).to_not have_content comments.last.content
    end

    scenario 'other entities are not present in the results' do
      expect(page).to_not have_content question.title
    end
  end
end
