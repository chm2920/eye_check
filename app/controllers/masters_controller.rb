#encoding: utf-8
class MastersController < ApplicationController
  
  before_action :set_cur
  before_action :set_master, only: [:edit, :update, :destroy]
  
  def index
    @masters = Master.paginate :page => params[:page], :per_page => 15, :order => "id desc"
  end

  def new
    @schools = School.all
    @master = Master.new
  end

  def edit
    @schools = School.all
  end
  
  def create
    @master = Master.new(master_params)
    m = Member.where(login_name: params[:master][:login_name])
    if !m.blank?
      @schools = School.all
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ms = Master.where(login_name: params[:master][:login_name])
    if !ms.blank?
      @schools = School.all
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ad = Admin.where(login_name: params[:master][:login_name])
    if !ad.blank?
      @schools = School.all
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    if @master.save
      redirect_to masters_url
    else
      render action: 'new'
    end
  end

  def update
    m = Member.where(login_name: params[:master][:login_name])
    if !m.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ms = Master.where(login_name: params[:master][:login_name])
    if !ms.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ad = Admin.where(login_name: params[:master][:login_name])
    if !ad.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    if @master.update_attributes(master_params)
      redirect_to masters_url
    else
      render action: 'edit'
    end
  end

  def destroy
    @master.destroy
    redirect_to masters_url
  end
  
  private
  
  def set_cur
    @cur = "master"
  end
  
  def set_master
    @master = Master.find(params[:id])
  end
  
  def master_params
    params.require(:master).permit!
  end
  
end
