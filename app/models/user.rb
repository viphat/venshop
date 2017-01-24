class User < ApplicationRecord
  extend Enumerize

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :encrypted_password, presence: true
  validates_confirmation_of :password

  devise :database_authenticatable, :registerable, :trackable, :omniauthable, :omniauth_providers => [:facebook]
  enumerize :role, in: [:admin, :user], default: :user, predicates: true
  has_attached_file :avatar, styles: { small: "64x64>", medium: "128x128>", large: "512x512>" }, default_url: '/images/default_avatar_:style.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.avatar = auth.info.image
    end
  end

end
