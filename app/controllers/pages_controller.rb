class PagesController < ApplicationController
include PagesHelper
    def index
      unless user_signed_in?
        redirect_to welcome_path
        return
      end
        @activities = []
    end

    def activities
      params[:dates] = { :to => "", :from=> ""} if params[:dates].nil?  #Coming straight into the page
      after  = params[:dates][:from].empty? ? Time.now - 30.days : Time.parse(params[:dates][:from])
      before = params[:dates][:to].empty?   ? Time.now : Time.parse(params[:dates][:to])

      @activities = get_all_activities(after,before)
      zone1 = get_activity_zone(@activities.first)
      ## TODO: Put in a routine that actual refreshes your token.
      if @activities.nil?
        redirect_to destroy_user_session_path
        return
      end

      @week_mileage = weekly_counter(@activities,after)
    end

    def welcome
    end

    private
    def weekly_counter(activities,start_from)
      week_mileage = {}
      next_week = start_from + 7.days
      key_week  = start_from
      sum = 0.0
      activities.reverse_each.with_index do |activity,index|
        if activity.start_date <= next_week
          sum += activity.distance_in_miles
          if index == activities.length-1
            week_mileage[key_week.to_date] = sum
          end
        else
          week_mileage[key_week.to_date] = sum
          sum = 0.0
          key_week = next_week
          next_week += 7.days
        end
      end
      return week_mileage
    end
end
