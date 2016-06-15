FactoryGirl.define do
  factory :feed do
    message "MyString"
    like_count 1
    comment_count 1
    user
  end
end
