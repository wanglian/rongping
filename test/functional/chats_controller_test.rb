require 'test_helper'

class ChatsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:chats)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_chat
    assert_difference('Chat.count') do
      post :create, :chat => { }
    end

    assert_redirected_to chat_path(assigns(:chat))
  end

  def test_should_show_chat
    get :show, :id => chats(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => chats(:one).id
    assert_response :success
  end

  def test_should_update_chat
    put :update, :id => chats(:one).id, :chat => { }
    assert_redirected_to chat_path(assigns(:chat))
  end

  def test_should_destroy_chat
    assert_difference('Chat.count', -1) do
      delete :destroy, :id => chats(:one).id
    end

    assert_redirected_to chats_path
  end
end
