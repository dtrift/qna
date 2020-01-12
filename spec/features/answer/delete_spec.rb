require 'rails_helper'

feature 'Delete his answer', %q{
  must be log in
  must be an author of answer
} do

  given(:user) { create :user }
  given(:a_user) { create :user }
  given!(:question) { create(:question, author: user) }
  # given!(:answers) { create_list :q_answers, 5, question: question, author: user }
  given!(:answer) { create :answer, question: question, author: user }


  scenario 'Author tries to delete his answer' do
    sign_in user
    visit question_path(question)

    expect(page).to have_content answer.body
    # save_and_open_page

    # answers.each do |answer|
    #   expect(page).to have_content answer.body
    #   click_on 'Delete answer'

    #   expect(page).to have_content 'Answer successfully deleted'
    #   expect(page).to_not have_content answer.body
    # end

    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario "Author tries to delete another's answer" do
    sign_in a_user
    visit question_path(question)

    expect(page).not_to have_link 'Delete answer'
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete answer'
  end
end
