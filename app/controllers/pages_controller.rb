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
      params[:dates] = { :to => "", :from=> ""} if params[:dates].nil?  #Coming straight into the page
      after  = params[:dates][:from].empty? ? Time.now - 30.days : Time.parse(params[:dates][:from])
      before = params[:dates][:to].empty?   ? Time.now : Time.parse(params[:dates][:to])
      @activities = get_all_activities(after,before)
      @week_mileage = []
      next_week = after + 7.days
      sum = 0.0
      @activities.reverse_each.with_index do |activity,index|
        if activity.start_date <= next_week
          print("Normal sum")
          sum += activity.distance_in_miles
          if index == @activities.length-1
            print("hit end of array")
            @week_mileage << sum
          end
        else
          print("Hit end of a week sum")
          @week_mileage << sum
          sum = 0.0
          next_week += 7.days
        end
      end
    end

    def welcome
    end
end
