class ChatroomsController < ApplicationController
  before_filter :login_required, :only => [:index, :show] unless guest_browse_enabled?
  before_filter :login_required, :except => [:index, :show]
  before_filter :can_edit, :only => [:update, :destroy]
  before_filter :find_chatroom, :except => [:index, :new, :create]
  
  # GET /chatrooms
  # GET /chatrooms.xml
  def index
    @chatrooms = Chatroom.paginate :order => 'created_at DESC', :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chatrooms }
    end
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chatroom }
    end
  end

  # GET /chatrooms/new
  # GET /chatrooms/new.xml
  def new
    @chatroom = Chatroom.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chatroom }
    end
  end

  # GET /chatrooms/1/edit
  def edit
    
  end

  # POST /chatrooms
  # POST /chatrooms.xml
  def create
    @chatroom = Chatroom.new(params[:chatroom])
    @chatroom.user = current_user

    respond_to do |format|
      if @chatroom.save
        flash[:notice] = '{object} was successfully {action}.'[:object_action_notice, "Chatroom"[], "created"[]]
        format.html { redirect_to(chatroom_chats_url(@chatroom)) }
        format.xml  { render :xml => @chatroom, :status => :created, :location => @chatroom }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chatroom.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chatrooms/1
  # PUT /chatrooms/1.xml
  def update
    
    respond_to do |format|
      if @chatroom.update_attributes(params[:chatroom])
        flash[:notice] = '{object} was successfully {action}.'[:object_action_notice, "Chatroom"[], "updated"[]]
        format.html { redirect_to(@chatroom) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chatroom.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.xml
  def destroy
    @chatroom.destroy

    respond_to do |format|
      format.html { redirect_to(chatrooms_url) }
      format.xml  { head :ok }
    end
  end
  
  def accept
    chat_user = @chatroom.chat_users.find_by_user_id params[:user_id]
    chat_user.activate!
    render :nothing => true
  end
  
  def leave
    chat_user = @chatroom.chat_users.find_by_user_id current_user
    chat_user.destroy if chat_user
    
    redirect_to chatrooms_url
  end
  
  private
  def find_chatroom
    @chatroom = Chatroom.find(params[:id])
  end
  
end
