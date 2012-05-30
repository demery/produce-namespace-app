class Produce::Fruit < ActiveRecord::Base
  attr_accessible :variety, :kind, :quantity

  validates_presence_of :kind
  validates_presence_of :variety

  validates_uniqueness_of :kind
end
