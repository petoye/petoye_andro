FactoryGirl.define do
  factory :comment do
    message "MyString"
    user_id 1
    post_id 1
  end
end
