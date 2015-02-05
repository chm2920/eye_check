class SchoolsController < ApplicationController
  
  before_action :set_school, only: [:edit, :update, :destroy, :upgrade, :downgrade]
  
  def index
    @schools = School.all
  end

  def new
    @school = School.new
  end

  def edit
  end
  
  def create
    @school = School.new(school_params)
    if @school.save
      redirect_to schools_url
    else
      render action: 'new'
    end
  end

  def update
    if @school.update_attributes(school_params)
      redirect_to schools_url
    else
      render action: 'edit'
    end
  end

  def destroy
    @school.destroy
    redirect_to schools_url
  end
  
  def upgrade
    @ks = K.where(school_id: @school.id)
    @ks.each do |k|
      k.grade = k.grade.to_i + 1
      k.save
    end
    redirect_to school_ks_url(@school)
  end
  
  def downgrade
    @ks = K.where(school_id: @school.id)
    @ks.each do |k|
      k.grade = k.grade.to_i - 1
      k.save
    end
    redirect_to school_ks_url(@school)
  end
  
  private
  
  def set_school
    @school = School.find(params[:id])
  end
  
  def school_params
    params.require(:school).permit!
  end
  
end
