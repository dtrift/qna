require 'rails_helper'

feature 'User can delete his question', %q{
  must be log in
  must be an author of question
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given(:a_user) { create :user }
  given(:a_question) { create :question, user: a_user }

  describe 'Authenticated user' do
    background { sign_in user }

    scenario 'tries to delete his question' do
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question successfully deleted'
      expect(page).to_not have_content question.title
    end

    scenario "tries to delete another's question" do
      visit question_path(a_question)

      expect(page).not_to have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end
