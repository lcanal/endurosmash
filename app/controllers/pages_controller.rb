class PagesController < ApplicationController
    def index
        if !user_signed_in?
            redirect_to welcome_path
        end
    end
    def welcome

    end
end
