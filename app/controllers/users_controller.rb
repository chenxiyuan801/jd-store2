class UsersController < ApplicationController

  def new
   @user = User.new
  end

  def create
    @user =User.new(user_params)

      if @user.save
        flash[:notice] = '注册成功～'
        redirect_to new_session_path
      else
        @user.errors
        render action: :new
      end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :cellphone, :token)
  end

end
