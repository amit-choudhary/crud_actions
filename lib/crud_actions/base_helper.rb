module BaseHelper

  private

    def path_maker
      index_path = public_send(:try, "#{ controller_name + '_path' }".to_sym)
      index_path || after_sign_in_path_for(current_account)
    end

    def get_translation_options(translation_variable, resource)
      translation_options = { scope: :flash }
      translation_options.merge!({ translation_variable => resource.public_send(translation_variable) }) if translation_variable
      translation_options
    end

end
