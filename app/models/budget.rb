class Budget < ApplicationRecord
  belongs_to :user
  validates_presence_of :amount


  private

end
