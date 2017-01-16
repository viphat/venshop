require 'open-uri'

class Item < ApplicationRecord

  belongs_to :category

  has_attached_file :item_image, styles: { small: "75x50>", medium: "160x105>", large: "500x330>" }
  validates_attachment_content_type :item_image, content_type: /\Aimage\/.*\z/

  def set_item_image_from_url(url)
    self.item_image = open(url)
  end

end
