class Admin::ForumsController < ApplicationController
  require_role :admin
  layout 'admin'
  
  def index
    @forums = Forum.find :all
  end
  
  def show
    @forum = Forum.find params[:id]
  end
  
  def new
    @forum = Forum.new
  end
  
  def edit
    @forum = Forum.find params[:id]
  end
  
  def create
    @forum = Forum.new params[:forum]
    
    respond_to do |format|
      if @forum.save
        flash[:notice] = "Forum was successfully created."
        format.html { redirect_to(admin_forum_url(@forum)) }
        format.xml  { render :xml => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @forum = Forum.find params[:id]
    @forum.update_attributes params[:forum]
    
    redirect_to admin_forum_url(@forum)
  end
  
  def destroy
    @forum = Forum.find params[:id]
    @forum.destroy
    
    redirect_to admin_forums_url
  end
  
end
