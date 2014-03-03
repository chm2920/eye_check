#encoding: utf-8
class KsController < ApplicationController
  
  before_action :find_school
  before_action :set_k, only: [:edit, :update, :destroy]
  
  def index
    @ks = K.where(school_id: @school.id).order("grade asc").group_by{|k|k.grade}
    
    if session[:role] == 'master'
      @chart_data = {}
      @chart_data["categories"] = []
      @chart_data["series"] = []
      @ks.each do |grade, _ks|
        case grade
        when "1"
          @chart_data["categories"] << "一年级"
        when "2"
          @chart_data["categories"] << "二年级"
        when "3"
          @chart_data["categories"] << "三年级"
        when "4"
          @chart_data["categories"] << "四年级"
        when "5"
          @chart_data["categories"] << "五年级"
        when "6"
          @chart_data["categories"] << "六年级"
        end
        
        total = 0
        jinshi = 0
        _ks.each do |k|
          members = k.members
          total += members.length
          members.each do |member|
            if !member.last_check_result
              jinshi += 1
            end
          end
        end
        if total == 0
          @chart_data["series"].push(0)
        else
          @chart_data["series"].push(jinshi * 100 / total)
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
