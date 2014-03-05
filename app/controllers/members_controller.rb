#encoding: utf-8
class MembersController < ApplicationController
  
  before_action :find_school_k
  before_action :set_member, only: [:edit, :update, :destroy]
  
  def index
    @members = Member.find(:all, :conditions => ["k_id = ?", @k.id], :order => "id desc")
  end

  def new
    @member = Member.new
  end

  def edit
  end
  
  def create
    @member = Member.new(member_params)
    m = Member.where(login_name: params[:member][:login_name])
    if !m.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ms = Master.where(login_name: params[:member][:login_name])
    if !ms.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ad = Admin.where(login_name: params[:member][:login_name])
    if !ad.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    @member.school = @school
    @member.k = @k
    if @member.save
      redirect_to school_k_members_url(@school, @k)
    else
      render action: 'new'
    end
  end

  def update
    m = Member.where(login_name: params[:member][:login_name])
    if !m.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ms = Master.where(login_name: params[:member][:login_name])
    if !ms.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ad = Admin.where(login_name: params[:member][:login_name])
    if !ad.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    if @member.update_attributes(member_params)
      redirect_to school_k_members_url(@school, @k)
    else
      render action: 'edit'
    end
  end

  def destroy
    @member.destroy
    redirect_to school_k_members_url(@school, @k)
  end
  
  private
  
  def set_member
    @member = Member.find(params[:id])
  end
  
  def find_school_k
    @school = School.find(params[:school_id])
    @k = K.find(params[:k_id])
  end
  
  def member_params
    params.require(:member).permit!
  end
  
end
