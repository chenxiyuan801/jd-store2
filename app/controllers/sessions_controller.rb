class SessionsController < ApplicationController

  def new

  end

  def create
    if user = login(params[:cellphone], params[:password])
      flash[:notice] = "登陆成功"
      redirect_to root_path
    else
      flash[:notice] = "手机号或者密码不正确"
      redirect_to new_session_path
    end
end

  def destroy
    logout
    cookies.delete :user_uuid
    flash[:notice] = "退出成功"
    redirect_to root_path
  end

end
