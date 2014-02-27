class SchoolsController < ApplicationController
  
  before_action :set_school, only: [:edit, :update, :destroy]
  
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
  
  private
  
  def set_school
    @school = School.find(params[:id])
  end
  
  def school_params
    params.require(:school).permit!
  end
  
end
