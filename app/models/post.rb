class Post < ActiveRecord::Base
  attr_accessible :body, :published, :title

  def self.most_recent
    Post.order("created_at desc").limit(1).first.id
  end
end
