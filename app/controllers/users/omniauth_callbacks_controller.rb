class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def strava
        @user = User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted?
            sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
            set_flash_message(:notice, :success, kind: "strava") if is_navigational_format?
        else
            #redirect_to = "I dont know you" path
            print "Who are you?"
        end
    end

    def failure
        print "I failed..."
        redirect_to root_path
    end
end