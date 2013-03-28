class Boardgame < ActiveRecord::Base
  attr_accessible :thumbnail
  has_attached_file :thumbnail

  has_many :categories
  has_many :honours
  has_many :mechanics
  has_many :subdomains
end
