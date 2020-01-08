require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  I'd like to be able to ask the question
} do

  scenario 'User asks a question' do
    visit new_question_path
    fill_in 'Title', with: 'SomeTitle'
    fill_in 'Body', with: 'SomeBody'
    click_on 'Create'

    # save_and_open_page
    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content 'SomeTitle'
    expect(page).to have_content 'SomeBody'
  end

  scenario 'User asks a question whith errors'
end
