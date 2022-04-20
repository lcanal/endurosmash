class PagesController < ApplicationController
include PagesHelper
    def index
        if !user_signed_in?
            redirect_to welcome_path
            return
        end
        @activities = []
    end

    def activities
        @start = Time.now()
        @end = Time.now() - 30.days
        @token = session[:access_token]

        client = Strava::Api::Client.new(access_token: session[:access_token])
        @activities = client.athlete_activities
        render "index"
    end

    def welcome
    end
end
