module CrudActionsHelper

  def index_helper(resource_name, options)
    if options[:search]
      search_index_helper(resource_name, options)
    else
      without_search_index_helper(resource_name, options)
    end
  end

  def search_index_helper(resource_name, options)
    @search = self.class.instance_variable_get('@resource_class').includes(options[:includes]).order(options[:order]).ransack(params[:q])
    instance_variable_set("@#{ resource_name.pluralize }", @search.result.paginate(page: params[:page], total_entries: @search.result.length))
  end

  def without_search_index_helper(resource_name, options)
    instance_variable_set("@#{ resource_name.pluralize }", self.class.instance_variable_get('@resource_class').includes(options[:includes]).order(options[:order]).paginate(page: params[:page]))
  end

end
