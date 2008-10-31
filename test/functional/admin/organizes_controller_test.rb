require 'test_helper'

class Admin::OrganizesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_organizes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_organize
    assert_difference('Admin::Organize.count') do
      post :create, :organize => { }
    end

    assert_redirected_to organize_path(assigns(:organize))
  end

  def test_should_show_organize
    get :show, :id => admin_organizes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => admin_organizes(:one).id
    assert_response :success
  end

  def test_should_update_organize
    put :update, :id => admin_organizes(:one).id, :organize => { }
    assert_redirected_to organize_path(assigns(:organize))
  end

  def test_should_destroy_organize
    assert_difference('Admin::Organize.count', -1) do
      delete :destroy, :id => admin_organizes(:one).id
    end

    assert_redirected_to admin_organizes_path
  end
end
