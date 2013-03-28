class Subdomain < ActiveRecord::Base
  belongs_to :boardgame
  attr_accessible :subdomain_value
end
