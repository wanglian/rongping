class BlogsController < ApplicationController
  before_filter :login_required, :only => [:index, :show] unless guest_browse_enabled?
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_blog, :except => [:index, :new, :create]
  before_filter :can_edit, :only => [:update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:set_blog_tag_list]
  in_place_edit_for :blog, :tag_list
  
  # GET /blogs
  # GET /blogs.xml
  def index
    if params[:search]
      @blogs = Blog.search(params[:search], :order => "created_at DESC")
      @tags = Blog.tag_counts
    elsif logged_in?
      if params[:tag]
        @blogs = Blog.paginate_tagged_with(params[:tag], :order => "blogs.created_at DESC", :page => params[:page])
      elsif params[:search]
        @blogs = Blog.search params[:search], :order => "created_at DESC"
      elsif params[:user]
        @user = User.find_by_login(params[:user])
        @blogs = @user ? Blog.paginate_by_user_id(@user.id, :order => "created_at DESC", :page => params[:page]) : [].paginate
      else
        @blogs = Blog.paginate :order => "created_at DESC", :page => params[:page]
      end
      @tags = Blog.tag_counts
    else
      if params[:tag] 
        @blogs = Blog.paginate_tagged_with(params[:tag], :order => "blogs.created_at DESC", :page => params[:page])
      elsif params[:search]
        @blogs = Blog.search(params[:search], :order => "created_at DESC")
      elsif params[:user]
        @user = User.find_by_login(params[:user])
        @blogs = Blog.paginate_by_user_id(@user.id, :order => "created_at DESC", :page => params[:page])
      else
        @blogs = Blog.paginate :order =>"created_at DESC", :page => params[:page]
      end
      @tags = Blog.tag_counts
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
      format.rss
    end
  end

  # GET /blogs/1
  # GET /blogs/1.xml
  def show
    if @blog
      @prev = Blog.find :first, :conditions => ["user_id = ? and created_at < ?", @blog.user_id, @blog.created_at], 
                        :order => "created_at DESC"
      @next = Blog.find :first, :conditions => ["user_id = ? and created_at > ?", @blog.user_id, @blog.created_at], 
                        :order => "created_at ASC"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.xml
  def create
    @blog = Blog.new(params[:blog])
    @blog.user = current_user

    respond_to do |format|
      if @blog.save
        flash[:notice] = '{object} was successfully {action}.'[:object_action_notice, "Blog"[], "created"[]]
        format.html { redirect_to(@blog) }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = '{object} was successfully {action}.'[:object_action_notice, "Blog"[], "updated"[]]
        format.html { redirect_to(@blog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_comment
    @comment = Comment.new :comment => params[:comment], :user => current_user
    @blog.comments << @comment
    respond_to do |format|
      format.js do
        render :update do |page|
          page.insert_html :bottom, :comments, :partial => 'comment', :object => @comment
          page[:comment_form].reset
        end
      end
    end
  end
  
  def delete_comment
    comment = @blog.comments.find params[:cid]
    comment.destroy if comment
    respond_to do |format|
      format.js   { render :nothing => true }
    end
  end
  
  private
  def find_blog
    @blog = Blog.find(params[:id])
  end
  
end
