require 'open-uri'

class Item < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }

  belongs_to :category

  has_attached_file :item_image, styles: { small: "51x32>", medium: "71x38>", large: "500x330>" }
  validates_attachment_content_type :item_image, content_type: /\Aimage\/.*\z/

  def set_item_image_from_url(url)
    self.item_image = open(url)
  end

end
