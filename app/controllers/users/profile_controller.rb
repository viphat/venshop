class Users::ProfileController < ApplicationController
  before_action :authenticate_user!
  layout 'without_sidebar'

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
    else
      flash[:error] = @user.errors.full_messages
    end
    render 'edit'
  end

  protected

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :avatar).reject { |k,v| v.blank? }
    end

end
