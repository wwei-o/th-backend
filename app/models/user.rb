class User < ApplicationRecord
  enum :role, { admin: 1, tourOperator: 2 }

  has_many :tours 
  has_many :slots
end
