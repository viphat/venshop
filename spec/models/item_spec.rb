require "rails_helper"

RSpec.describe Item, :type => :model do

  context 'check by shoulda matchers' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to delegate_method(:category_name).to(:category) }

    it { is_expected.to validate_presence_of(:item_name) }
    it { is_expected.to validate_length_of(:item_name)
                        .is_at_least(10)
                        .is_at_most(255) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to have_attached_file(:item_image) }
    it { is_expected.to validate_attachment_content_type(:item_image)
          .allowing('image/png', 'image/jpeg', 'image/bmp', 'image/gif')
          .rejecting('text/plain', 'text/xml') }
  end

end
