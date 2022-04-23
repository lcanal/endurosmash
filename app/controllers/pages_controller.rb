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
      if @activities.nil?
        redirect_to destroy_user_session_path
        return
      end

      @week_mileage       = weekly_counter(@activities,after)
      zones               = get_activity_zones(@activities)
      @week_pace_zones    = time_spent_in_pace_zones(zones)
    end

    def welcome
    end

    private
    def weekly_counter(activities,start_from)
      week_mileage = {}
      next_week = start_from + 7.days       # May want to make this an option
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

    def time_spent_in_pace_zones(pace_zones)
      pace_zone_sums = { "Zone 1" => 0, "Zone 2" => 0, "Zone 3" => 0, "Zone 4" => 0, "Zone 5" => 0}
      pace_zones.each do |z|
        pace_zone_sums['Zone 1'] += z['z1'].time
        pace_zone_sums['Zone 2'] += z['z2'].time
        pace_zone_sums['Zone 3'] += z['z3'].time
        pace_zone_sums['Zone 4'] += z['z4'].time
        pace_zone_sums['Zone 5'] += z['z5'].time
      end
      return pace_zone_sums
    end

end
