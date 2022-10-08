class ApplicationController < ActionController::Base
  layout :layout_by_resource
  
  private
    def layout_by_resource
      devise_controller? ? "#{resource_class.to_s.downcase}_devise" : "application"
    end
end
