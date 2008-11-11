class TopicsController < ApplicationController
  before_filter :login_required, :only => [:index, :show] unless guest_browse_enabled?
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_forum
  before_filter :can_edit, :only => [:destroy]
  before_filter :can_view, :only => [:index, :show]
  
  # GET /topics
  # GET /topics.xml
  def index
    if params[:search]
      @topics = @forum.topics.search params[:search], :order => "created_at DESC"
    else
      @topics = @forum.topics.paginate :order => "created_at DESC", :page => params[:page]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = @forum.topics.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user

    respond_to do |format|
      if @forum.topics << @topic
        flash[:notice] = '{object} was successfully {action}.'[:object_action_notice, "Topic"[], "created"[]]
        format.html { redirect_to(forum_topic_path(@forum, @topic)) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = @forum.topics.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(forum_topics_url(@forum)) }
      format.xml  { head :ok }
    end
  end
  
  def add_comment
    @topic = @forum.topics.find(params[:id])
    @comment = Comment.new :comment => params[:comment], :user_id => current_user.id
    @topic.comments << @comment
    respond_to do |format|
      format.html { redirect_to(forum_topic_path(@forum, @topic)) }
      format.js do
        render :update do |page|
          page.insert_html :bottom, :comments, :partial => 'comment', :object => @comment
          page[:comment_form].reset
        end
      end
    end
  end
  
  def delete_comment
    @topic = @forum.topics.find(params[:id])
    comment = @topic.comments.find params[:cid]
    comment.destroy if comment
    respond_to do |format|
      format.html { redirect_to(forum_topic_path(@forum, @topic)) }
      format.js   { render :nothing => true }
    end
  end
  
  private
  def find_forum
    @forum = Forum.find params[:forum_id]
  end
  
  def can_view
    if @forum.owner
      redirect_to forums_url unless @forum.owner.public? || @forum.owner.has_member?(current_user) # temp
    end
  end
end
