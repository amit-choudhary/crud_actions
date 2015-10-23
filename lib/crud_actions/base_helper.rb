module CrudActions
  module BaseHelper

    private
      def path_maker
        { action: :index, controller: controller_name }
      end
  end
end
