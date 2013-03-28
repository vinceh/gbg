class Category < ActiveRecord::Base
  belongs_to :boardgame
  attr_accessible :category_value
end
