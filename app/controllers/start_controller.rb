#encoding: utf-8
class StartController < ApplicationController
  
  def index
    if session["role"]
      redirect_to "/main"
      return
    end
    render :layout => false
  end
  
  def login_rst
    if !params[:username].blank? && !params[:password].blank?
      @member = Member.find_by_login_name(params[:username])
      if @member.nil?
        @master = Master.find_by_login_name(params[:username])
        if @master.nil?
          @admin = Admin.find_by_login_name(params[:username])
          if @admin.nil?
            @login_rst = 0
            @err_msg = "用户名密码错误!"
          else
            if @admin.login_pwd == params[:password]
              @login_rst == 1
              session["role"] = "admin"
              session[:admin_id] = @admin.id
              redirect_to "/main"
              return
            else
              @login_rst = 0
              @err_msg = "用户名密码错误!"
            end
          end
        else
          if @master.login_pwd == params[:password]
            @login_rst == 1
            session["role"] = "master"
            session[:master_id] = @master.id
            redirect_to "/main"
            return
          else
            @login_rst = 0
            @err_msg = "用户名密码错误!"
          end
        end
      else
        if @member.login_pwd == params[:password]
          @login_rst == 1
          session["role"] = "member"
          session[:member_id] = @member.id
          redirect_to "/main"
          return
        else
          @login_rst = 0
          @err_msg = "用户名密码错误!"
        end
      end
    else
      @login_rst = 0
      @err_msg = "用户名密码不能为空。"
    end
    if @login_rst != 1
      render :action => "index", :layout => false
    end
  end
  
  def main
    case session[:role]
    when "admin"
      redirect_to "/schools"
    when "master"
      @master = Master.find(session[:master_id])
      @school = @master.school
      redirect_to "/schools/#{@school.id}/ks"
    when "member"
      @member = Member.find(session[:member_id])
      @checks = @member.checks
      if @checks.length > 1
        @last_check = @checks.first
      else
        if @checks.length == 1
          @first_check = @checks.first
        end
      end
      @chart_data = @member.checks_data_for_chart
    else
      redirect_to "/"
    end
  end
  
  def pwd
    if session[:role].nil?
      redirect_to :action => "main"
      return 
    end
    @cur = "admin"
  end
  
  def pwd_rst
    if session[:role].nil?
      redirect_to :action => "main"
      return 
    end
    params.permit!
    case session[:role]
    when "admin"
      @user = Admin.find(session[:admin_id])
    when "master"
      @user = Master.find(session[:master_id])
    when "member"
      @user = Member.find(session[:member_id])
    end
    if params[:password] == params[:re_password]
      @user.login_pwd = params[:password]
      @user.save
      redirect_to :action => "main"
    else
      redirect_to :action => "pwd"
    end
  end
  
  def logout
    session["role"] = nil
    redirect_to '/'
  end
  
end
