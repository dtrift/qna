require 'rails_helper'

feature 'User can view the question', %q{
  The user can view the question 
  and answers to it.
} do

  given!(:question) { create :question }
  given!(:answers) { create_list :q_answers, 2, question: question }

  scenario 'User view the question with answers' do
    visit question_path(question)
    
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
