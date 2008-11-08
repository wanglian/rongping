class ForumsController < ApplicationController
  before_filter :login_required, :only => [:index] unless guest_browse_enabled?
  before_filter :login_required, :except => [:index]
  
  def index
    @forums = Forum.find :all, :conditions => {:owner_type => nil, :owner_id => nil}, :order => 'created_at DESC'
    
    if @forums.length == 1
      redirect_to forum_topics_url(@forums.first) and return
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
    end
  end
  
end
