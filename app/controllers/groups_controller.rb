class GroupsController < ApplicationController
  before_filter :login_required, :only => [:index, :show] unless guest_browse_enabled?
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_group, :except => [:index, :new, :create]
  before_filter :can_edit, :only => [:update, :destroy]
  before_filter :can_accept, :only => [:accept, :reject]
  
  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.paginate :order => 'created_at DESC', :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @forum = Forum.find_by_owner @group
    if @forum
      @topics = @forum.topics.paginate :order => "created_at DESC", :page => params[:page]
    else
      @topics = [].paginate
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    @group.user = current_user

    respond_to do |format|
      if @group.save
        @group.add_member current_user
        flash[:notice] = '{object} was successfully {action}.'[:object_action_notice, "Group"[], "created"[]]
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = '{object} was successfully {action}.'[:object_action_notice, "Group"[], "updated"[]]
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
      format.js   { render :nothing => true }
    end
  end
  
  def join
    @group.add_member current_user
    
    if @group.public?
      flash[:notice] = "You have joined the group."[:group_join_message]
    elsif @group.protected?
      flash[:notice] = "You have applied to join this group."[:group_apply_message]
    else
      # TODO
    end
    
    respond_to do |format|
      format.html { redirect_to group_url(@group) }
    end
  end
  
  def accept
    user = User.find params[:user_id]
    if user && @group.accept_member(user)
      flash[:notice] = "You allowed {name} become a memer of this group."[:group_accept_message, user.name]
    end
    
    respond_to do |format|
      format.html { redirect_to group_url(@group) }
    end
  end
  
  def reject
    user = User.find params[:user_id]
    @group.reject_member(user) if user
    
    respond_to do |format|
      format.html { redirect_to group_url(@group) }
      format.js   { render :nothing => true }
    end
  end
  
  def leave
    group_user = @group.group_users.find_by_user_id current_user.id
    group_user.destroy if group_user
    
    respond_to do |format|
      flash[:notice] = "You have left the group."[:group_leave_message]
      format.html { redirect_to group_url(@group) }
    end
  end
  
  private
  def find_group
    @group = Group.find(params[:id])
  end
  
  def can_accept
    redirect_to groups_url unless @group.user == current_user
  end
  
end
