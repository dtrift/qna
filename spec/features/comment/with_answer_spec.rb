require 'rails_helper'

feature 'User can post a comment', %q{
  As an any user
  I'd like to be able to post comment's
  For the answer
} do

  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: user }
  
  scenario 'User post a comment', js: true do
    visit question_path(question)

    within '.answer-comments' do
      click_on 'Add comment'
      fill_in 'Your comment', with: 'Some Comment'
      click_on 'Post'
    end

    expect(page).to have_content 'Some Comment'
  end

  scenario 'User post a comment with errors', js: true do
    visit question_path(question)

    within '.answer-comments' do
      click_on 'Add comment'
      click_on 'Post'
    end

    expect(page).to have_content 'Сontent can\'t be blank'
  end

  describe 'Multiple sessions', js: true do
    scenario 'comment appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path

        within '.answer-comments' do
          click_on 'Add comment'
          fill_in 'Your comment', with: 'Some Comment'
          click_on 'Post'
        end

        expect(page).to have_content 'Some Comment'
      end

      Capybara.using_session('guest') do
        visit questions_path

        expect(page).to have_content 'Some Comment'
      end
    end
  end
end
