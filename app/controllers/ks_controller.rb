class KsController < ApplicationController
  
  before_action :find_school
  before_action :set_k, only: [:edit, :update, :destroy]
  
  def index
    @ks = K.find(:all, :conditions => ["school_id = ?", @school.id], :order => "grade asc").group_by{|k|k.grade}
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
