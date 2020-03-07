require 'sphinx_helper'

feature 'User can search for question', %q{
  As an Anyone user
  I'd like to be able to search for the question
  In order to find needed question  
} do

  scenario 'User searches for the question', sphinx: true, js:true do
    visit questions_path

    ThinkingSphinx::Test.run do
       # код теста
    end
  end
end
