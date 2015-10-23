module CrudActions
  module ActionsHelper

    def index_helper(resource_name, options)
      instance_variable_set("@#{ resource_name.pluralize }", self.class.instance_variable_get('@resource_class').includes(options[:includes]).order(options[:order]))
    end

  end
end
