class User < ApplicationRecord
  extend Enumerize
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :items, dependent: :destroy

  validates :email, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :encrypted_password, presence: true
  validates_confirmation_of :password, :only => :create

  devise :database_authenticatable, :registerable, :trackable
  enumerize :role, in: [:admin, :user], default: :user, predicates: true
  has_attached_file :item_image, styles: { small: "64x64>", medium: "128x128>", large: "512x512>" }, default_url: {}
  validates_attachment_content_type :item_image, content_type: /\Aimage\/.*\z/

end
