require 'test_helper'

class ChatroomsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:chatrooms)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_chatroom
    assert_difference('Chatroom.count') do
      post :create, :chatroom => { }
    end

    assert_redirected_to chatroom_path(assigns(:chatroom))
  end

  def test_should_show_chatroom
    get :show, :id => chatrooms(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => chatrooms(:one).id
    assert_response :success
  end

  def test_should_update_chatroom
    put :update, :id => chatrooms(:one).id, :chatroom => { }
    assert_redirected_to chatroom_path(assigns(:chatroom))
  end

  def test_should_destroy_chatroom
    assert_difference('Chatroom.count', -1) do
      delete :destroy, :id => chatrooms(:one).id
    end

    assert_redirected_to chatrooms_path
  end
end
