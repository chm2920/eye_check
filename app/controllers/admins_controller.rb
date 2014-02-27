class AdminsController < ApplicationController
  
  before_action :set_cur
  before_action :set_admin, only: [:edit, :update, :destroy]
  
  def index
    @admins = Admin.paginate :page => params[:page], :per_page => 15, :order => "id desc"
  end

  def new
    @admin = Admin.new
  end

  def edit
  end
  
  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      redirect_to admins_url
    else
      render action: 'new'
    end
  end

  def update
    if @admin.update_attributes(admin_params)
      redirect_to admins_url
    else
      render action: 'edit'
    end
  end

  def destroy
    @admin.destroy
    redirect_to admins_url
  end
  
  private
  
  def set_cur
    @cur = "admin"
  end
  
  def set_admin
    @admin = Admin.find(params[:id])
  end
  
  def admin_params
    params.require(:admin).permit!
  end
  
end
