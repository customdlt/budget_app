class Budget < ApplicationRecord
  belongs_to :user
  validates_presence_of :amount
  validates_numericality_of :amount
end
