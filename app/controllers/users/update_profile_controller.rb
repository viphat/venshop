class Users::UpdateProfileController < ApplicationController
  before_action :authenticate_user!
  layout 'without_sidebar'

  def new; end

  def create

  end

end
