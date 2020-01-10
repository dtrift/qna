require 'rails_helper'

feature 'User can create answer', %q{
  The user on the question page
  As an authenticated user
  Can write the answer to the question
} do

  given(:user) { create :user }
  given(:question) { create :question }

  background do
    sign_in(user)

    visit new_question_answer_path(question)
  end

  scenario 'Authenticated user gives an answer' do
    fill_in 'Body', with: 'Some Answer'
    click_on 'Add answer'

    expect(page).to have_content 'Answer successfully added'
  end

  scenario 'Authenticated user gives an answer with errors' do
    click_on 'Add answer'

    expect(page).to have_content "Body can't be blank"
  end

end
