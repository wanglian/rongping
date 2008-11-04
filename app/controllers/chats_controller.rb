class ChatsController < ApplicationController
  before_filter :login_required
  before_filter :find_chatroom
  
  # GET /chats
  # GET /chats.xml
  def index
    @chats = @chatroom.chats
    
    unless @chats.empty?
      session[:chat_id] = @chats.first.id
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chats }
    end
  end

  # POST /chats
  # POST /chats.xml
  def create
    @chat = Chat.new(params[:chat])
    @chat.user = current_user

    respond_to do |format|
      if @chatroom.chats << @chat
        # ChatUser.active(@chatroom.id, current_user.id)
        
        format.js do
          render :update do |page|
            page.insert_html :top, :chats, :partial => 'chat', :object => @chat
            page.visual_effect :highlight, "chat-body-#{@chat.id}"
          end
        end
      else
        format.js {render :nothing => true}
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.xml
  def destroy
    @chat = @chatroom.chats.find(params[:id])
    @chat.destroy if @chat && can_destroy?(@chatroom, @chat)

    respond_to do |format|
      format.html { redirect_to(chatroom_chats_url(@chatroom)) }
      format.xml  { head :ok }
      format.js { render :nothing => true }
    end
  end
  
  def refresh
    @chats = Chat.refresh(session[:chat_id], @chatroom.id, current_user)
    ChatUser.active(@chatroom.id, current_user.id)
    
    render :update do |page|
      unless @chats.empty?
        session[:chat_id] = @chats.last.id
        @chats.each do |chat|
          page << "if ($('chat-#{chat.id}')){"
          page << '}else{'
          page.insert_html :top, 'chats', :partial => 'chat', :object => chat
          page.visual_effect :highlight, "chat-body-#{chat.id}"
          page << '}'
        end
      end
      page.replace_html :online_users, :partial => 'online_users', :object => @chatroom.online_users.dup
    end
  end

  private
  def find_chatroom
    @chatroom = Chatroom.find params[:chatroom_id]
  end
  
  def can_destroy?(chatroom, chat)
    return (current_user.admin? || chatroom.user == current_user || chat.user == current_user) ? true : false
  end
  
end
