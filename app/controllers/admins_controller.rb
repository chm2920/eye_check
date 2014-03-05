#encoding: utf-8
class AdminsController < ApplicationController
  
  before_action :set_cur
  before_action :set_admin, only: [:edit, :update, :destroy]
  
  def index
    @admins = Admin.paginate :page => params[:page], :per_page => 15, :order => "id desc"
  end

  def new
    @admin = Admin.new
  end

  def edit
  end
  
  def create
    @admin = Admin.new(admin_params)
    m = Member.where(login_name: params[:admin][:login_name])
    if !m.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ms = Master.where(login_name: params[:admin][:login_name])
    if !ms.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ad = Admin.where(login_name: params[:admin][:login_name])
    if !ad.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    if @admin.save
      redirect_to admins_url
    else
      render action: 'new'
    end
  end

  def update
    m = Member.where(login_name: params[:admin][:login_name])
    if !m.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ms = Master.where(login_name: params[:admin][:login_name])
    if !ms.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ad = Admin.where(login_name: params[:admin][:login_name])
    if !ad.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    if @admin.update_attributes(admin_params)
      redirect_to admins_url
    else
      render action: 'edit'
    end
  end

  def destroy
    @admin.destroy
    redirect_to admins_url
  end
  
  private
  
  def set_cur
    @cur = "admin"
  end
  
  def set_admin
    @admin = Admin.find(params[:id])
  end
  
  def admin_params
    params.require(:admin).permit!
  end
  
end
