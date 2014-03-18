#encoding: utf-8
class KsController < ApplicationController
  
  before_action :find_school
  before_action :set_k, only: [:edit, :update, :destroy]
  
  def index
    @ks = K.where(school_id: @school.id).order("grade asc").group_by{|k|k.grade}
    
    if session[:role] == 'master'
      @school_data = {}
      @school_data["categories"] = [@school.name]
      @school_data["js"] = []
      @school_data["rs"] = []
      total = 0
      js = 0
      rs = 0
      
      @chart_data = {}
      @chart_data["categories"] = []
      @chart_data["js"] = []
      @chart_data["rs"] = []
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
        
        g_total = 0
        g_js = 0
        g_rs = 0
        _ks.each do |k|
          members = k.members
          g_total += members.length
          total += members.length
          members.each do |member|
            if member.last_check_rst
              if member.last_check_rst == '近视'
                g_js += 1
                js += 1
              end
              if member.last_check_rst == '弱视'
                g_rs += 1
                rs += 1
              end
            end
          end
        end
        if g_total == 0
          @chart_data["js"] << 0
          @chart_data["rs"] << 0
        else
          @chart_data["js"] << g_js * 100 / g_total
          @chart_data["rs"] << g_rs * 100 / g_total
        end
      end
      if total == 0
        @school_data["js"] << 0
        @school_data["rs"] << 0
      else
        @school_data["js"] << js * 100 / total
        @school_data["rs"] << rs * 100 / total
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
