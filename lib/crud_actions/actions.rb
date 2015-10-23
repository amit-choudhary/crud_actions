#This module is for basic crud actions. It expect two methods to be defined in controller.
# First is permitted_params_for_create and other is permitted_params_for_update

module CrudActions

  include BaseHelper
  include CrudActionsHelper
  extend ActiveSupport::Concern
  DEFAULT_ACTIONS = [:index, :new, :create, :edit, :update, :show, :destroy]

  def self.included(class_name)
    model_name = class_name.to_s.split('Controller')[0].singularize
    class_name.instance_variable_set('@resource_class', model_name.constantize)
    class_name.instance_variable_set('@resource_name', model_name.underscore)
  end

  module ClassMethods
    def has_inherited_actions(*actions)
      excluded_actions = ::CrudActions::DEFAULT_ACTIONS - actions
      self.send(:undef_method, *excluded_actions)
    end
  end

  def index(options = { order: :name, search: false, includes: nil })
    index_helper(controller_name, options)
  end

  def new
    resource_name = self.class.instance_variable_get('@resource_name')
    instance_variable_set("@#{ resource_name }", self.class.instance_variable_get('@resource_class').new)
  end

  def create(options = {})
    resource_name = self.class.instance_variable_get('@resource_name')
    instance_variable_set("@#{ resource_name }", self.class.instance_variable_get('@resource_class').new(permitted_params_for_create))
    if instance_variable_get("@#{ resource_name }").public_send(:save)
      flash[:notice] = t('.success', scope: :flash)
      redirect_to (options[:redirect_to] || path_maker)
    else
      render action: :new
    end
  end

  def edit
  end

  def show
  end

  def update(options = {})
    resource_name = self.class.instance_variable_get('@resource_name')
    if instance_variable_get("@#{ resource_name }").public_send(:update, permitted_params_for_update)
      flash[:notice] = t('.success', scope: :flash)
      redirect_to (options[:redirect_to] || path_maker)
    else
      render action: :edit
    end
  end

  def destroy(options = {})
    resource_name = self.class.instance_variable_get('@resource_name')
    resource = instance_variable_get("@#{ resource_name }")
    if resource.public_send(:destroy)
      flash.now[:notice] = t('.success', get_translation_options(options[:translation_variable], resource))
    else
      flash.now[:error] = resource.errors.full_messages.join(', ')
    end
  end

end
