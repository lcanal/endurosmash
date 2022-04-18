class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def strava
        # User connections go here
    end

    def failure
        redirect_to root_path
    end
end