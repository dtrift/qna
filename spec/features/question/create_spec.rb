require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  I'd like to be able to ask the question
} do

  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }

  background do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit new_question_path
  end

  scenario 'User asks a question' do
    fill_in 'Title', with: 'SomeTitle'
    fill_in 'Body', with: 'SomeBody'
    click_on 'Create'

    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content 'SomeTitle'
    expect(page).to have_content 'SomeBody'
  end

  scenario 'User asks a question with errors' do
    click_on 'Create'

    expect(page).to have_content "Title can't be blank"
  end
end
