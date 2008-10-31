class Admin::OrganizesController < ApplicationController
  require_role :admin
  layout 'admin'
  
  # GET /organizes
  # GET /organizes.xml
  def index
    @organizes = Organize.paginate :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organizes }
    end
  end

  # GET /organizes/1
  # GET /organizes/1.xml
  def show
    @organize = Organize.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organize }
    end
  end

  # GET /organizes/new
  # GET /organizes/new.xml
  def new
    @organize = Organize.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organize }
    end
  end

  # GET /organizes/1/edit
  def edit
    @organize = Organize.find(params[:id])
  end

  # POST /organizes
  # POST /organizes.xml
  def create
    @organize = Organize.new(params[:organize])

    respond_to do |format|
      if @organize.save
        flash[:notice] = 'Organize was successfully created.'
        format.html { redirect_to(admin_organize_path(@organize)) }
        format.xml  { render :xml => @organize, :status => :created, :location => @organize }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organize.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organizes/1
  # PUT /organizes/1.xml
  def update
    @organize = Organize.find(params[:id])

    respond_to do |format|
      if @organize.update_attributes(params[:organize])
        flash[:notice] = 'Organize was successfully updated.'
        format.html { redirect_to(@organize) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organize.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organizes/1
  # DELETE /organizes/1.xml
  def destroy
    @organize = Organize.find(params[:id])
    @organize.destroy

    respond_to do |format|
      format.html { redirect_to(organizes_url) }
      format.xml  { head :ok }
    end
  end
  
  def new_user
    @organize = Organize.find(params[:id])
  end
  
  def create_user
    @organize = Organize.find(params[:id])
    
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        @user.roles.clear
        @user.roles << Role.find_by_name('customer')
        @organize.user = @user
        @organize.save
        flash[:notice] = "User was successfully created."
        format.html { redirect_to(admin_organize_url(@organize)) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new_user" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show_user
    @organize = Organize.find(params[:id])
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html # show_user.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  
end
