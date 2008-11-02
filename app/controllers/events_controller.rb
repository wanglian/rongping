class EventsController < ApplicationController
  before_filter :login_required, :only => [:index, :show] unless guest_browse_enabled?
  before_filter :login_required, :except => [:index, :show]
  before_filter :load_event, :except => [:index, :new, :create]
  before_filter :load_date, :only => [:index, :show]
  before_filter :can_edit, :only => [:update, :destroy]
  
  def index
    @month_events = Event.monthly_events(@date)
    unless filter_by_day?
      @events = @month_events
    else
      @events = Event.daily_events(@date)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  def show
    @month_events = Event.monthly_events(@date).user_events(current_user)
    @attendees = @event.attendees
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def edit
  end

  def create
    @event = Event.new(params[:event].merge(:user => current_user))

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  def attend
    if @event.attend(current_user)
      flash[:notice] = "You are attending this event."
      redirect_to @event
    else
      flash[:error] = "You can only attend once."
      redirect_to @event
    end
  end

  def unattend
    if @event.unattend(current_user)
      flash[:notice] = "You are not attending this event."
      redirect_to @event
    else
      flash[:error] = "You are not attending this event."
      redirect_to @event
    end
  end
  
  def add_comment
    @comment = Comment.new :comment => params[:comment], :user_id => current_user.id
    @event.comments << @comment
    respond_to do |format|
      format.html { redirect_to event_url(@event) }
      format.js do
        render :update do |page|
          page.insert_html :bottom, :comments, :partial => 'comment', :object => @comment
          page[:comment_form].reset
        end
      end
    end
  end
  
  def delete_comment
    comment = @event.comments.find params[:cid]
    comment.destroy if comment
    respond_to do |format|
      format.html { redirect_to event_url(@event) }
      format.js   { render :nothing => true }
    end
  end
  
  private
    def load_date
      if @event
        @date = @event.start_time
      else
        now = Time.now
        year = (params[:year] || now.year).to_i
        month = (params[:month] || now.month).to_i
        day = (params[:day] || 1).to_i
        @date = DateTime.new(year,month,day)
        puts @date
      end
    rescue ArgumentError => e
      @date = Time.now
      puts e
    end

    def filter_by_day?
      !params[:day].nil?
    end

    def load_event
      @event = Event.find(params[:id])
    end

end
