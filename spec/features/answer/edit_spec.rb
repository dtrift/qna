require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:author) { create :user }
  given(:user) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in author
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        # save_and_open_page
        fill_in 'Your Answer', with: 'Edited Answer'
        # save_and_open_page
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited Answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit other user's question"
  end
end
