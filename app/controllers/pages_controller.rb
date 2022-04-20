class PagesController < ApplicationController
include PagesHelper
    def index
        if !user_signed_in?
            redirect_to welcome_path
            return
        end
        # @token = session[:access_token]
        #client = Strava::Api::Client.new(access_token: session[:access_token])
        #@activities = client.athlete_activities
        
        print sample_data
        @activities = sample_data
    end

    def welcome
    end
end
