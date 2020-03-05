FactoryBot.define do
  factory :answer do
    user
    question
    
    body { "MyText" }

    trait :invalid do
      body { nil }
    end

    trait :add_file do
      after :create do |answer|
        file_path = Rails.root.join('public', 'favicon.ico')
        file = fixture_file_upload(file_path, 'image/ico')
        answer.files.attach(file)
      end
    end

    factory :q_answers do
      sequence(:body) do |n| 
        "#{n}. Some Answer"
      end
    end
  end


end
