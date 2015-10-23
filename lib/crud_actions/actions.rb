require 'crud_actions/base_helper'
require 'crud_actions/actions_helper'

module CrudActions
  module Actions

    include ::CrudActions::BaseHelper
    include ::CrudActions::ActionsHelper
    extend ActiveSupport::Concern

    DEFAULT_ACTIONS = [:index, :new, :create, :edit, :update, :show, :destroy]

    def self.included(class_name)
      model_name = class_name.to_s.split('Controller').first.split('::').last.singularize
      class_name.instance_variable_set('@resource_class', model_name.constantize)
      class_name.instance_variable_set('@resource_name', model_name.underscore)
    end

    module ClassMethods
      def has_inherited_actions(*actions)
        excluded_actions = DEFAULT_ACTIONS - actions
        self.send(:undef_method, *excluded_actions)
      end
    end

    def index(options = { order: nil, includes: nil })
      index_helper(controller_name, options)
    end

    def new
      resource_name = self.class.instance_variable_get('@resource_name')
      instance_variable_set("@#{ resource_name }", self.class.instance_variable_get('@resource_class').new)
    end

    def create(options = { notice: nil, alert: nil })
      resource_name = self.class.instance_variable_get('@resource_name')
      resource_class = self.class.instance_variable_get('@resource_class')
      instance_variable_set("@#{ resource_name }", resource_class.new(permitted_params_for_create))
      resource = instance_variable_get("@#{ resource_name }")
      if resource.public_send(:save)
        flash[:notice] = options[:notice] || "#{ resource_class.to_s } created successfully."
        redirect_to (options[:redirect_to] || path_maker)
      else
        flash[:alert] = options[:alert] || resource.errors.full_messages.join(', ')
        render action: :new
      end
    end

    def edit
    end

    def show
    end

    def update(options = { notice: nil, alert: nil })
      resource_name = self.class.instance_variable_get('@resource_name')
      resource_class = self.class.instance_variable_get('@resource_class')
      resource = instance_variable_get("@#{ resource_name }")
      if resource.public_send(:update, permitted_params_for_update)
        flash[:notice] = options[:notice] || "#{ resource_class.to_s } updated successfully."
        redirect_to (options[:redirect_to] || path_maker)
      else
        flash[:alert] = options[:alert] || resource.errors.full_messages.join(', ')
        render action: :edit
      end
    end

    def destroy(options = { notice: nil, alert: nil })
      resource_name = self.class.instance_variable_get('@resource_name')
      resource_class = self.class.instance_variable_get('@resource_class')
      resource = instance_variable_get("@#{ resource_name }")
      if resource.public_send(:destroy)
        flash[:notice] = options[:notice] || "#{ resource_class.to_s } destroyed successfully."
      else
        flash[:alert] = options[:alert] || resource.errors.full_messages.join(', ')
      end
      redirect_to (options[:redirect_to] || path_maker)
    end

  end
end
