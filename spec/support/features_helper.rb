module FeaturesHelper
  RSpec.shared_context 'login_as_user', shared_context: :feature do

    let(:current_user) { FactoryGirl.create(:user) }

    before(:each) do
      login_as(current_user, scope: :user)
    end

  end

end
