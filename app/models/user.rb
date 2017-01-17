class User < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :email, uniqueness: true, format: { with: Devise::email_regexp }
  validates :name, presence: true
  validates :encrypted_password, presence: true

  devise :database_authenticatable, :registerable, :trackable
end
