class Slot < ApplicationRecord
  enum :status, { active: 1, ended: 2, cancelled: 3 }

  belongs_to :user
  belongs_to :tour
end
