require 'test_helper'

class CrudActionsTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, CrudActions
  end
end

class Category < ActiveRecord::Base
end

class CategoriesController < ActionController::Base
  include CrudActions::Actions
  has_inherited_actions :index, :new, :create, :show, :destroy, :update, :edit

  def permitted_params_for_create
    params.require(:category).permit!
  end

  def permitted_params_for_update
    params.require(:category).permit!
  end
end


class CategoriesControllerTest < ActionController::TestCase

  def setup
    @controller = CategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test 'controller should have an index action' do
    get :index
    assert_response :success
  end

  test 'an instance variable should be assigned inside index' do
    get :index
    assert assigns(:categories)
  end

  test 'index action should render index page' do
    get :index
    assert_template :index
  end

  test 'controller should have an edit action and render edit template' do
    get :edit, {id: 2}
    assert_template :edit
  end

  test 'controller should have an update action and renders edit page on erroneous submission' do
    @controller.instance_variable_set('@category', Category.new({id: '1', text: 'Crud Actions'}))
    @controller.instance_variable_get('@category').expects(:update).returns(false)
    patch :update, ({id: 1, category: {text: 'New Crud Actions'}})
    assert_template :edit
    assert_match @controller.flash[:notice].to_s, ''
  end

  test 'controller should have update method and redirects on successful submission' do
    @controller.instance_variable_set('@category', Category.new({id: '1', text: 'Crud Actions'}))
    @controller.instance_variable_get('@category').expects(:update).returns(true)
    patch :update, ({id: 1, category: {text: 'New Crud Actions'}})
    assert_redirected_to categories_path
    assert_match @controller.flash[:notice], 'Category updated successfully.'
  end

  test 'controller should have a new action and assigns an instance variable' do
    get :new
    assert_response :success
    assert_equal 'New HTML', @response.body.strip
    assert assigns(:category)
  end

  test 'controller should have a create action and redirects on successful submission' do
    Category.any_instance.stubs(:save).returns(true)
    put :create, category: {text: 'Crud Actions'}
    assert assigns(:category)
    assert_redirected_to categories_path
    assert_match @controller.flash[:notice], 'Category created successfully.'
  end

  test 'controller should have a create action and renders new page on erroneous submission' do
    Category.any_instance.stubs(:save).returns(false)
    get :create, category: {text: 'Crud Actions'}
    assert assigns(:category)
    assert_response :success
    assert_template :new
  end

  test 'controller should have a show action' do
    get :show, {id: '2'}
    assert_template :show
  end

  test 'controller should have a destroy action and shows flash[:notice] for successful submission' do
    @controller.instance_variable_set('@category', Category.new({id: '1', text: 'Crud Actions'}))
    @controller.instance_variable_get('@category').expects(:destroy).returns(true)
    delete :destroy, {id: '2'}
    assert_redirected_to categories_path
    assert_match @controller.flash[:notice], 'Category destroyed successfully.'
  end

  test 'controller should have a destroy method and shows flash[:errors] for erroneous submission' do
    @controller.instance_variable_set('@category', Category.new({id: '1', text: 'Crud Actions'}))
    @controller.instance_variable_get('@category').expects(:destroy).returns(false)
    delete :destroy, {id: '2'}
    assert_redirected_to categories_path
    assert_match @controller.flash[:notice].to_s, ''
  end

end

class Product < ActiveRecord::Base
end

class ProductsController < ActionController::Base
  include CrudActions::Actions
  has_inherited_actions :index, :new, :create, :show, :destroy

  def permitted_params_for_update
    params.require(:category).permit!
  end
end

class ProductsControllerTest < ActionController::TestCase
  test 'controller should raise exception when action not defined' do
    begin
      patch :update, ({id: 1, product: {name: 'New Crud Actions'}})
    rescue Exception => e
      assert_match "The action 'update' could not be found for ProductsController", e.message
    end
  end

  test 'should indicate absence of "permitted_params_for_create" for create action when not defined' do
    begin
      put :create
    rescue Exception => e
      assert_match /undefined local variable or method `permitted_params_for_create'/, e.message
    end
  end
end
