class AdminsBackofficeController < ApplicationController
    layout 'admins_backoffice'
    before_action :authenticate_admin!
end
