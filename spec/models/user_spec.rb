require "rails_helper"

RSpec.describe User, type: :model do

  context 'check by shoulda matchers' do
    subject(:user) { FactoryGirl.build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:encrypted_password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to enumerize(:role).in(:admin, :user).with_default(:user) }
    it { is_expected.to have_attached_file(:avatar) }
    it { is_expected.to validate_attachment_content_type(:avatar)
          .allowing('image/png', 'image/jpeg', 'image/bmp', 'image/gif')
          .rejecting('text/plain', 'text/xml') }

  end

  shared_examples_for 'check validity of email' do |email, result|
    let(:user) { FactoryGirl.build(:user)}
    it "should return #{result} when email is #{email}" do
      user.email = email
      expect(user.valid?).to eq result
    end
  end

  it_behaves_like 'check validity of email', "viphat@gmail.com", true
  it_behaves_like 'check validity of email', "viphat@gmail", false
  it_behaves_like 'check validity of email', "viphat.work", false
  it_behaves_like 'check validity of email', "viphat@.com", false
  it_behaves_like 'check validity of email', "viph*at@@gmail.com", false

end
