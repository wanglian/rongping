class ChatsController < ApplicationController
  before_filter :login_required, :find_chatroom
  
  # GET /chats
  # GET /chats.xml
  def index
    @chats = Chat.find_all_by_chatroom_id @chatroom.id, :order => "created_at DESC"
    
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
        format.js do
          render :update do |page|
            page.insert_html :top, :chats, :partial => 'chat', :object => @chat
            page.visual_effect :highlight, "chat-#{@chat.id}"
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
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to(chatroom_chats_url(@chatroom)) }
      format.xml  { head :ok }
    end
  end
  
  def refresh
    @chats = Chat.refresh(session[:chat_id], @chatroom.id, current_user)
    unless @chats.empty?
      session[:chat_id] = @chats.first.id
      render :update do |page|
        @chats.reverse.each do |chat|
          page << "if ($('chat-#{chat.id}')){"
          page << '}else{'
          page.insert_html :top, 'chats', :partial => 'chat', :object => chat
          page.visual_effect :highlight, "chat-#{chat.id}"
          page << '}'
        end
      end
    else
      render :nothing => true
    end
  end

  private
  def find_chatroom
    @chatroom = Chatroom.find params[:chatroom_id]
  end
  
end
