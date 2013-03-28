class Honour < ActiveRecord::Base
  belongs_to :boardgame
  attr_accessible :honour_value
end
