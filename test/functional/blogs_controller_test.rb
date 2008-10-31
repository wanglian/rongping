require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:blogs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_blog
    assert_difference('Blog.count') do
      post :create, :blog => { }
    end

    assert_redirected_to blog_path(assigns(:blog))
  end

  def test_should_show_blog
    get :show, :id => blogs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => blogs(:one).id
    assert_response :success
  end

  def test_should_update_blog
    put :update, :id => blogs(:one).id, :blog => { }
    assert_redirected_to blog_path(assigns(:blog))
  end

  def test_should_destroy_blog
    assert_difference('Blog.count', -1) do
      delete :destroy, :id => blogs(:one).id
    end

    assert_redirected_to blogs_path
  end
end
