class MembersController < ApplicationController
  
  before_action :find_school_k
  before_action :set_member, only: [:edit, :update, :destroy]
  
  def index
    @members = Member.find(:all, :conditions => ["k_id = ?", @k.id], :order => "id asc")
  end

  def new
    @member = Member.new
  end

  def edit
  end
  
  def create
    @member = Member.new(member_params)
    @member.school = @school
    @member.k = @k
    if @member.save
      redirect_to school_k_members_url(@school, @k)
    else
      render action: 'new'
    end
  end

  def update
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
