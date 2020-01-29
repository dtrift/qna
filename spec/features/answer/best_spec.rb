require 'rails_helper'

feature 'Set a best answers', %q{
  Author of question
  Set one of answers
  As the best answer
} do

  given(:author) { create :user }
  given(:user) { create :user }
  given(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }

  describe 'Authenticated question author', js: true do
    scenario 'set the best answer' do
      sign_in author

      visit question_path(question)

      within ".answer-#{answer.id}" do
        click_on 'Best answer'

        expect(page).to_not have_link 'Best answer'
      end
    end

    scenario 'A non author of question tries to set the best answer' do
      sign_in user

      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end
