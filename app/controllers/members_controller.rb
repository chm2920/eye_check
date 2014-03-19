#encoding: utf-8
class MembersController < ApplicationController
  
  before_action :find_school_k
  before_action :set_member, only: [:edit, :update, :destroy]
  
  def index
    @members = Member.find(:all, :conditions => ["k_id = ?", @k.id], :order => "id asc")
    if session[:role] == 'master'
      l_checks = @members.last.checks.length - 1
      @chart_data = {}
      @chart_data["js"] = []
      @chart_data["rs"] = []
      
      @total = @members.length
      0.upto l_checks do
        @chart_data["js"] << 0
      end
      0.upto l_checks do
        @chart_data["rs"] << 0
      end
      
      @members.each do |member|
        member.check_rsts.each_with_index do |rst, i|
          if rst.check_result == '近视' #&& i <= l_checks
            if @chart_data["js"][i]
              @chart_data["js"][i] += 1
            else
              @chart_data["js"] << 1
            end
          end
          if rst.check_result == '弱视'
            if @chart_data["rs"][i]
              @chart_data["rs"][i] += 1
            else
              @chart_data["rs"] << 1
            end
          end
        end
      end
      
      if @total != 0
        @chart_data["js"].each_with_index do |js, i|
          @chart_data["js"][i] = js * 100 / @total
        end
        @chart_data["rs"].each_with_index do |rs, i|
          @chart_data["rs"][i] = rs * 100 / @total
        end
      end
    end
  end

  def new
    @member = Member.new
  end

  def edit
  end
  
  def create
    @member = Member.new(member_params)
    m = Member.where(login_name: params[:member][:login_name].strip)
    if !m.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ms = Master.where(login_name: params[:member][:login_name].strip)
    if !ms.blank?
      @err_msg = "用户名已存在"
      render action: 'new'
      return
    end
    ad = Admin.where(login_name: params[:member][:login_name].strip)
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
    m = Member.where(login_name: params[:member][:login_name].strip)
    if !m.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ms = Master.where(login_name: params[:member][:login_name].strip)
    if !ms.blank?
      @err_msg = "用户名已存在"
      render action: 'edit'
      return
    end
    ad = Admin.where(login_name: params[:member][:login_name].strip)
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
