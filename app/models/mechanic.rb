class Mechanic < ActiveRecord::Base
  belongs_to :boardgame
  attr_accessible :mechanic_value
end
