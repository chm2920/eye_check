class ChecksController < ApplicationController
  
  before_action :find_member
  before_action :set_check, only: [:show, :edit, :update, :destroy]
  before_action :set_check_by_check_id, only: [:intervention, :intervention_edit, :intervention_update]
  
  def index
    @checks = Check.find(:all, :conditions => ["member_id = ?", @member.id], :order => "id desc")
  end
  
  def show
    @params = JSON.parse @check.params
    if @check.is_first?
      @first = 1
    end
  end

  def new
    if @member.checks.length == 0
      @first = 1
    end
    @check = Check.new
  end

  def edit
    @params = JSON.parse @check.params
    if @check.is_first?
      @first = 1
    end
  end
  
  def create
    @check = Check.new
    @check.member_id = @member.id
    @check.check_date = params[:check_date]
    @check.check_result = params[:check_result]
    @check.params = params[:check].to_json
    if @check.save
      redirect_to checks_path(member_id: @member.id)
    else
      render action: 'new'
    end
  end

  def update
    @check.check_date = params[:check_date]
    @check.check_result = params[:check_result]
    @check.params = params[:check].to_json
    if @check.save
      redirect_to checks_path(member_id: @member.id)
    else
      render action: 'edit'
    end
  end

  def destroy
    @check.destroy
    redirect_to checks_path(member_id: @member.id)
  end
  
  def intervention
    if @check.intervention
      @intervention = JSON.parse @check.intervention
    end
  end
  
  def intervention_edit
    if @check.intervention
      @intervention = JSON.parse @check.intervention
    end
  end
  
  def intervention_update
    @check.intervention = params[:intervention].to_json
    @check.save
    redirect_to checks_path(member_id: @member.id)
  end
  
  private
  
  def set_check
    @check = Check.find(params[:id])
  end
  
  def set_check_by_check_id
    @check = Check.find(params[:check_id])
  end
  
  def find_member
    @member = Member.find(params[:member_id] || session[:member_id])
    @k = @member.k
    @school = @member.school
  end
  
  def check_params
    params.require(:check).permit!
  end
  
end
