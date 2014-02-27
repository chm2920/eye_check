class AdminController < ApplicationController
  
  def main
    @schools = School.all
  end
  
  def new_school
    case request.method
    when "POST"
      params.permit!
      @school = School.new(params[:school])
      @school.save
      redirect_to :action => "main"
    else
      @school = School.new
    end
  end
  
  def edit_school
    @school = School.find(params[:id])
    case request.method
    when "POST"
      params.permit!
      @school.name = params[:school][:name]
      @school.save
      redirect_to :action => "main"
    end
  end
  
  def del_school
    @school = School.find(params[:id])
    @school.destroy
    redirect_to :action => "main"
  end
  
  def cls
    @school = School.find(params[:id])
    @clss = Cls.find(:all, :conditions => ["school_id = ?", @school.id], :order => "grade asc").group_by{|cls|cls.grade}
    # @clss = @school.clss.group_by{|cls|cls.grade}
  end
  
  def new_cls
    @school = School.find(params[:id])
    case request.method
    when "POST"
      params.permit!
      @cls = Cls.new(params[:cls])
      @cls.school_id = @school.id
      @cls.save
      redirect_to :action => "cls", :id => @school.id
    else
      @cls = Cls.new
    end
  end
  
  def edit_cls
    @cls = Cls.find(params[:id])
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @cls.grade = params[:cls][:grade]
      @cls.name = params[:cls][:name]
      @cls.save
      redirect_to :action => "cls", :id => @cls.school_id
    end
  end
  
  def del_cls
    @cls = Cls.find(params[:id])
    @cls.destroy
    redirect_to :action => "cls", :id => @cls.school_id
  end
  
  def members
    @cls = Cls.find(params[:id])
    @school = @cls.school
    @members = @cls.members
  end
  
  def new_member
    @cls = Cls.find(params[:id])
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @member = Member.new(params[:member])
      @member.school_id = @school.id
      @member.cls_id = @cls.id
      @member.save
      redirect_to :action => "members", :id => @cls.id
    else
      @member = Member.new
    end
  end
  
  def edit_member
    @member = Member.find(params[:id])
    @cls = @member.cls
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @member.update_attributes(params[:member])
      redirect_to :action => "members", :id => @member.cls_id
    end
  end
  
  def del_member
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to :action => "members", :id => @member.cls_id
  end
  
  def check_list
    @member = Member.find(params[:id])
    @cls = @member.cls
    @school = @cls.school
    @checks = @member.checks
    @first_check = @member.first_check
  end
  
  def new_first_check
    @member = Member.find(params[:id])
    @cls = @member.cls
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @first_check = FirstCheck.new
      @first_check.member_id = @member.id
      @first_check.check_date = params[:check_date]
      @first_check.check_result = params[:check_result]
      @first_check.params = params[:check].to_json
      @first_check.save
      #render :text => params[:check]
      redirect_to :action => "check_list", :id => @member.id
    else
      @first_check = FirstCheck.new
    end
  end
  
  def edit_first_check
    @first_check = FirstCheck.find(params[:id])
    @params = JSON.parse @first_check.params
    @member = @first_check.member
    @cls = @member.cls
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @first_check.check_date = params[:check_date]
      @first_check.check_result = params[:check_result]
      @first_check.params = params[:check].to_json
      @first_check.save
      redirect_to :action => "check_list", :id => @member.id
    end
  end
  
  def del_first_check
    @first_check = FirstCheck.find(params[:id])
    @first_check.destroy
    redirect_to :action => "check_list", :id => @first_check.member_id
  end
  
  def new_check
    @member = Member.find(params[:id])
    @cls = @member.cls
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @check = Check.new
      @check.member_id = @member.id
      @check.check_date = params[:check_date]
      @check.check_result = params[:check_result]
      @check.params = params[:check].to_json
      @check.save
      redirect_to :action => "check_list", :id => @member.id
    else
      @check = Check.new
    end
  end
  
  def edit_check
    @check = Check.find(params[:id])
    @params = JSON.parse @check.params
    @member = @check.member
    @cls = @member.cls
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @check.check_date = params[:check_date]
      @check.check_result = params[:check_result]
      @check.params = params[:check].to_json
      @check.save
      redirect_to :action => "check_list", :id => @member.id
    end
  end
  
  def del_check
    @check = Check.find(params[:id])
    @check.destroy
    redirect_to :action => "check_list", :id => @check.member_id
  end
  
  def intervention_first
    @first_check = FirstCheck.find(params[:id])
    @member = @first_check.member
    @cls = @member.cls
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @first_check.intervention = params[:intervention].to_json
      @first_check.save
      redirect_to :action => "check_list", :id => @member.id
    else
      if @first_check.intervention
        @intervention = JSON.parse @first_check.intervention
      end
    end
  end
  
  def intervention
    @check = Check.find(params[:id])
    @member = @check.member
    @cls = @member.cls
    @school = @cls.school
    case request.method
    when "POST"
      params.permit!
      @check.intervention = params[:intervention].to_json
      @check.save
      redirect_to :action => "check_list", :id => @member.id
    else
      if @check.intervention
        @intervention = JSON.parse @check.intervention
      end
    end
  end
  
  def masters
    @masters = Master.all
    @cur = "master"
  end
  
  def new_master
    case request.method
    when "POST"
      params.permit!
      @master = Master.new(params[:master])
      @master.save
      redirect_to :action => "masters"
    else
      @master = Master.new
      @schools = School.all
      @cur = "master"
    end
  end
  
  def edit_master
    @master = Master.find(params[:id])
    case request.method
    when "POST"
      params.permit!
      @master.update_attributes(params[:master])
      @master.save
      redirect_to :action => "masters"
    else
      @schools = School.all
      @cur = "master"
    end
  end
  
  def del_master
    @master = Master.find(params[:id])
    @master.destroy
    redirect_to :action => "masters"
  end
  
  def admins
    @admins = Admin.all
    @cur = "admin"
  end
  
  def new_admin
    case request.method
    when "POST"
      params.permit!
      @admin = Admin.new(params[:admin])
      @admin.save
      redirect_to :action => "admins"
    else
      @admin = Admin.new
      @cur = "admin"
    end
  end
  
  def edit_admin
    @admin = Admin.find(params[:id])
    case request.method
    when "POST"
      params.permit!
      @admin.update_attributes(params[:admin])
      @admin.save
      redirect_to :action => "admins"
    else
      @cur = "admin"
    end
  end
  
  def del_admin
    @admin = Admin.find(params[:id])
    @admin.destroy
    redirect_to :action => "admins"
  end
  
  def pwd
    if session[:admin_id].nil?
      redirect_to :action => "main"
      return 
    end
    @admin = Admin.find(session[:admin_id])
    case request.method
    when "POST"
      params.permit!
      if params[:password] == params[:re_password]
        @admin.login_pwd = params[:password]
        @admin.save
        redirect_to :action => "main"
      else
        redirect_to :action => "pwd"
      end
    else
      @cur = "admin"
    end
  end
  
end
