class ProfilesBackofficeController < ApplicationController
    layout 'profiles_backoffice'
    before_action :authenticate_profile!
end
