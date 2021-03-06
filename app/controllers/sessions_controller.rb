class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase) 
    if user && user.authenticate(params[:session][:password])  
      if user.activated? 
        log_in user 
        params[:session][:remember_me] == '1' ? remember(user) : forget(user) 
        redirect_back_or user 
      else 
        message = "账号未激活，" 
        message += "请查看邮件激活账户" 
        flash[:warning] = message 
        redirect_to root_url 
      end
    else
      flash.now[:danger] = '发生错误'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
