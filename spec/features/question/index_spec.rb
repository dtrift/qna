require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  I'd like to be able to ask the question
} do

  given!(:questions) { create_list(:s_questions, 3) }

  scenario 'User can view a list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title    
      expect(page).to have_content question.body
    end
  end
end
