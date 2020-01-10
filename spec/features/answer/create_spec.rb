require 'rails_helper'

feature 'User can create answer', %q{
  The user on the question page 
  can write the answer to the question
} do

  given(:question) { create :question }

  scenario 'User gives an answer' do
    visit new_question_answer_path(question)
    fill_in 'Body', with: 'Some Answer'
    click_on 'Add answer'

    expect(page).to have_content 'Answer successfully added'
  end

  scenario 'User gives an answer with errors'

end