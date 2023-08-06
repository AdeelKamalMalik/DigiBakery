class Oven < ApplicationRecord
  belongs_to :user
  has_many :cookies, as: :storage, dependent: :destroy, class_name: "Cookie"

  validates :user, presence: true
end
