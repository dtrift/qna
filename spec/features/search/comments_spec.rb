require 'sphinx_helper'

feature 'User can search for comment', %q{
  As an Anyone user
  I'd like to be able to search for the comment
  In order to find needed comment  
} do

  given(:question) { create :question }
  given(:comments) { create_list :comment, 2, commentable: question }

  given!(:comment) {
    create :comment,
    commentable: question,
    content: 'Test Content for the comment1'
  }

  background { visit root_path }

  scenario 'Searches for the comments', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'test content'
      click_on 'Find'

      expect(page).to have_content comment.content
      expect(page).to_not have_content comments.first.content
      expect(page).to_not have_content comments.last.content
    end
  end
end
