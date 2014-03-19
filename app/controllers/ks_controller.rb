#encoding: utf-8
class KsController < ApplicationController
  
  before_action :find_school
  before_action :set_k, only: [:edit, :update, :destroy]
  
  def index
    @ks = K.where(school_id: @school.id).order("grade asc").group_by{|k|k.grade}
    
    if session[:role] == 'master'
      l_checks = Member.last.checks.length - 1
      @school_data = {}
      @school_data["js"] = []
      0.upto l_checks do
        @school_data["js"] << 0
      end
      @school_data["rs"] = []
      0.upto l_checks do
        @school_data["rs"] << 0
      end
      total = 0
      
      @chart_data = []
      @ks.each do |grade, _ks|
        data = {}
        
        case grade
        when "1"
          data["name"] = "一年级"
        when "2"
          data["name"] = "二年级"
        when "3"
          data["name"] = "三年级"
        when "4"
          data["name"] = "四年级"
        when "5"
          data["name"] = "五年级"
        when "6"
          data["name"] = "六年级"
        end
        
        data["js"] = []
        0.upto l_checks do
          data["js"] << 0
        end
        data["rs"] = []
        0.upto l_checks do
          data["rs"] << 0
        end
        
        g_total = 0
        _ks.each do |k|
          members = k.members
          g_total += members.length
          total += members.length
          members.each do |member|
            member.check_rsts.each_with_index do |rst, i|
              if rst.check_result == '近视' #&& i <= l_checks
                if data["js"][i]
                  data["js"][i] += 1
                else
                  data["js"] << 1
                end
              end
              if rst.check_result == '弱视'
                if data["rs"][i]
                  data["rs"][i] += 1
                else
                  data["rs"] << 1
                end
              end
            end
          end
        end
        data["js"].each_with_index do |js, i|
          if @school_data["js"][i]
            @school_data["js"][i] += js
          else
            @school_data["js"] << js
          end
        end
        data["rs"].each_with_index do |rs, i|
          if @school_data["rs"][i]
            @school_data["rs"][i] += rs
          else
            @school_data["rs"] << rs
          end
        end
        if g_total != 0
          data["js"].each_with_index do |js, i|
            data["js"][i] = js * 100 / g_total
          end
          data["rs"].each_with_index do |rs, i|
            data["rs"][i] = rs * 100 / g_total
          end
        end
        @chart_data << data
      end
      if total != 0
        @school_data["js"].each_with_index do |js, i|
          @school_data["js"][i] = js * 100 / total
        end
        @school_data["rs"].each_with_index do |rs, i|
          @school_data["rs"][i] = rs * 100 / total
        end
      end
    end
  end

  def new
    @k = K.new
  end

  def edit
  end
  
  def create
    @k = K.new(k_params)
    @k.school = @school
    if @k.save
      redirect_to school_ks_url(@school)
    else
      render action: 'new'
    end
  end

  def update
    if @k.update_attributes(k_params)
      redirect_to school_ks_url(@school)
    else
      render action: 'edit'
    end
  end

  def destroy
    @k.destroy
    redirect_to school_ks_url(@school)
  end
  
  private
  
  def set_k
    @k = K.find(params[:id])
  end
  
  def find_school
    @school = School.find(params[:school_id])
  end
  
  def k_params
    params.require(:k).permit!
  end
  
end
