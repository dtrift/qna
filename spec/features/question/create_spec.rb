require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an Authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create :user }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      
      visit new_question_path
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'SomeTitle'
      fill_in 'Body', with: 'SomeBody'
      click_on 'Create'

      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content 'SomeTitle'
      expect(page).to have_content 'SomeBody'
    end

    scenario 'asks a question with errors' do
      click_on 'Create'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unuthenticated user try asks a question' do
    visit new_question_path
    expect(page).to_not have_content 'Create'
  end
end
