#encoding: utf-8
class KsController < ApplicationController
  
  before_action :find_school
  before_action :set_k, only: [:edit, :update, :destroy]
  
  def index
    @ks = K.where(school_id: @school.id).order("grade asc").group_by{|k|k.grade}
    
    if session[:role] == 'master'
      
      @school_data = {}
      @school_data["jingshi"] = []
      @school_data["ruoshi"] = []
      @school_data["member"] = []
      
      @grade_jingshi = []
      @grade_ruoshi = []
      
      data = {}
      @ks.each do |grade, _ks|
        data[grade] = {}
        data[grade]["jingshi"] = {}
        data[grade]["ruoshi"] = {}
        data[grade]["member"] = {}
        case grade
        when "1"
          data[grade]["name"] = "一年级"
        when "2"
          data[grade]["name"] = "二年级"
        when "3"
          data[grade]["name"] = "三年级"
        when "4"
          data[grade]["name"] = "四年级"
        when "5"
          data[grade]["name"] = "五年级"
        when "6"
          data[grade]["name"] = "六年级"
        end
        _ks.each do |k|
          members = k.members
          members.each do |member|
            member.check_rsts.each_with_index do |rst, i|
              i = i.to_s
              if data[grade]["jingshi"][i].nil?
                data[grade]["jingshi"][i] = 0
              end
              if data[grade]["ruoshi"][i].nil?
                data[grade]["ruoshi"][i] = 0
              end
              if data[grade]["member"][i].nil?
                data[grade]["member"][i] = 0
              end
              if rst.check_result == '近视'
                data[grade]['jingshi'][i] += 1
              end
              if rst.check_result == '弱视'
                data[grade]['ruoshi'][i] += 1
              end
              data[grade]["member"][i] += 1
            end
          end
        end
      end
      
      data.each do |k, v|
        grade_jingshi = {}
        grade_jingshi["name"] = v["name"]
        grade_jingshi["js"] = []
        grade_ruoshi = {}
        grade_ruoshi["name"] = v["name"]
        grade_ruoshi["rs"] = []
        
        v["jingshi"].each do |k2, v2|
          if @school_data["jingshi"][k2.to_i].nil?
            @school_data["jingshi"][k2.to_i] = 0
          end
          @school_data["jingshi"][k2.to_i] += v2
          
          if grade_jingshi["js"][k2.to_i].nil?
            grade_jingshi["js"][k2.to_i] = 0
          end
          grade_jingshi["js"][k2.to_i] += v2
        end
        v["ruoshi"].each do |k2, v2|
          if @school_data["ruoshi"][k2.to_i].nil?
            @school_data["ruoshi"][k2.to_i] = 0
          end
          @school_data["ruoshi"][k2.to_i] += v2
          
          if grade_ruoshi["rs"][k2.to_i].nil?
            grade_ruoshi["rs"][k2.to_i] = 0
          end
          grade_ruoshi["rs"][k2.to_i] += v2
        end
        v["member"].each do |k2, v2|
          if @school_data["member"][k2.to_i].nil?
            @school_data["member"][k2.to_i] = 0
          end
          @school_data["member"][k2.to_i] += v2
        end
        @grade_jingshi << grade_jingshi
        @grade_ruoshi << grade_ruoshi
      end 
      
      
      @jingshi_data = []
      @school_data["jingshi"].each_with_index do |v, i|
        @jingshi_data[i] = v * 100.0 / @school_data["member"][i]
      end
      @ruoshi_data = []
      @school_data["ruoshi"].each_with_index do |v, i|
        @ruoshi_data[i] = v * 100.0 / @school_data["member"][i]
      end
      
      @grade_jingshi_data = []
      @grade_jingshi.each do |v|
        obj = {}
        obj["name"] = v["name"]
        obj["js"] = []
        v["js"].each_with_index do |val, i|
          if @school_data["jingshi"][i] == 0
            obj["js"] << 0
          else
            obj["js"] << val * 100.0 / @school_data["jingshi"][i]
          end
        end
        @grade_jingshi_data << obj
      end
      
      @grade_ruoshi_data = []
      @grade_ruoshi.each do |v|
        obj = {}
        obj["name"] = v["name"]
        obj["rs"] = []
        v["rs"].each_with_index do |val, i|
          if @school_data["ruoshi"][i] == 0
            obj["rs"] << 0
          else
            obj["rs"] << val * 100.0 / @school_data["ruoshi"][i]
          end
        end
        @grade_ruoshi_data << obj
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
