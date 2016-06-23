class FeedSerializer < ActiveModel::Serializer
  attributes :id,:message, :like_count, :comment_count
  #has_one :user
end
