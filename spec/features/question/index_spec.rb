require 'rails_helper'

feature 'User can see list of questions' do

  given(:user) { create :user }
  given!(:questions) { create_list :s_questions, 3, author: user }

  scenario 'User can view a list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title    
      expect(page).to have_content question.body
    end
  end
end
