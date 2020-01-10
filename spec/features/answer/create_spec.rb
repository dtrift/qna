require 'rails_helper'

feature 'User can create answer', %q{
  The user on the question page 
  can write the answer to the question
} do

  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }
  given(:question) { create :question }

  background do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit new_question_answer_path(question)
  end

  scenario 'User gives an answer' do
    fill_in 'Body', with: 'Some Answer'
    click_on 'Add answer'

    expect(page).to have_content 'Answer successfully added'
  end

  scenario 'User gives an answer with errors' do
    click_on 'Add answer'

    expect(page).to have_content "Body can't be blank"
  end

end
