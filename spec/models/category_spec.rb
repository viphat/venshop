require "rails_helper"

RSpec.describe Category, type: :model do

  context 'check by shoulda matchers' do
    subject(:category) { FactoryGirl.build(:category) }
    it { is_expected.to have_many(:items).dependent(:destroy) }
    it { is_expected.to validate_presence_of(:category_name) }
    it { is_expected.to validate_uniqueness_of(:category_name).case_insensitive }
    it { is_expected.to validate_length_of(:category_name)
                        .is_at_most(255) }
  end

end
