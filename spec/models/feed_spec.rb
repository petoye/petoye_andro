require 'spec_helper'

describe Feed do
  let(:feed) { FactoryGirl.build :feed }
  subject { feed }

  it { should respond_to(:message) }
  it { should respond_to(:like_count) }
  it { should respond_to(:comment_count) }
  it { should respond_to(:user_id) }

  it { should_not be :published }

  it { should validate_presence_of :message }
  it { should validate_presence_of :like_count }
  it { should validate_presence_of :comment_count }
  it { should validate_presence_of :user_id }
  it { should belong_to :user }
end
