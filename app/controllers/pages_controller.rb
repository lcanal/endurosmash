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
      
      zones               = get_activity_zones(@activities)
      @week_mileage       = weekly_counter(@activities,after)
      @week_pace_zones    = time_spent_in_pace_zones(zones)
    end

    def welcome
    end

    private
    def weekly_counter(activities,start_from)
      weekly_data = []
      weekly_data << {name: "Run", data: sum_by_type(activities,"Run",start_from)}
      weekly_data << {name: "Ride", data: sum_by_type(activities,"Ride",start_from)}
      weekly_data
    end

    def time_spent_in_pace_zones(pace_zones)
      pace_zone_sums = { "Zone 1" => 0, "Zone 2" => 0, "Zone 3" => 0, "Zone 4" => 0, "Zone 5" => 0, "Zone 6" => 0}
      pace_zones.each do |z|
        pace_zone_sums['Zone 1'] += z['zone1']
        pace_zone_sums['Zone 2'] += z['zone2']
        pace_zone_sums['Zone 3'] += z['zone3']
        pace_zone_sums['Zone 4'] += z['zone4']
        pace_zone_sums['Zone 5'] += z['zone5']
        pace_zone_sums['Zone 6'] += z['zone6']
      end
      return pace_zone_sums
    end

    def sum_by_type(activities,type,start_from)
      weekly_mileage = []
      next_week = start_from + 7.days       # May want to make this an option
      key_week  = start_from
      sum = 0.0

      filtered_activities = []
      activities.reverse.each do |activity|
        if activity.type.match?(type)
          filtered_activities << activity
        end
      end

      filtered_activities.each.with_index do |activity,index|
        sum += activity.distance_in_miles
        if activity.start_date <= next_week
          weekly_mileage << [key_week.to_date,sum]
        else
          sum = 0.0
          sum += activity.distance_in_miles
          key_week = next_week
          next_week += 7.days
          weekly_mileage << [key_week.to_date,sum]
        end # endif week comparison
      end # end activity loop
      weekly_mileage
    end

end