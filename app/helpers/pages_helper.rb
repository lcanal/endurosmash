module PagesHelper
  def get_all_activities(after,before)
    begin
      client = Strava::Api::Client.new(access_token: session[:access_token])
      activities = []
      page = 1
      until (page_of_activities = client.athlete_activities(:after => after, :before => before, :page => page, :per_page => 200)).size == 0 do
        activities += page_of_activities
        page += 1
      end
      return activities
    rescue Strava::Errors::Fault => e
      # e.message # => Bad Request
      # e.errors # => [{ 'code' => 'invalid', 'field' => 'code', 'resource' => 'RequestToken' }]
      # e.headers # => { "status" => "403 Bad Request", "x-ratelimit-limit" => "600,30000", "x-ratelimit-usage" => "314,27536" }
      print(e.headers)
      if e.headers["status"] == "401 Unauthorized"
        return nil
      end
    end
  end

  # TODO: Currently just returns pace zones, could also add HR
  def get_activity_zones(activities)
    pace_zones = []
    saved_zones = current_user.activity_zones.select("aid")
    activities.each do |activity|
      if !saved_zones.find_by_aid(activity.id).nil?
        pace_zones << current_user.activity_zones.select("zone1,zone2,zone3,zone4,zone5,zone6").find_by_aid(activity.id)
      else
        zones = get_zone_activity_from_strava(activity)
        pace_zones << zones unless zones.empty?
      end 
    end
    pace_zones
  end

  def get_zone_activity_from_strava(activity)
    pace_zones = []
    begin
      client = Strava::Api::Client.new(access_token: session[:access_token])
      zones = client.activity_zones(activity.id)
      zones.each do |zone|
        if (zone.include? 'type') && (zone.type == "pace")
          distribution_buckets = zone.distribution_buckets
          azs  = get_distribution_buckets(distribution_buckets)
          pace_zones << azs
          save_activity_zone(azs,activity.id,"pace")
        end #endif
      end #end zoneloop
    rescue Strava::Errors::Fault => e
      print(e.headers)
      if e.headers["status"] == "401 Unauthorized"
        zones = nil
      end
    end
    pace_zones
  end

  def get_distribution_buckets(distribution_buckets)
    pace_distribution = {}
    pace_distribution['zone1'] = distribution_buckets[0].time
    pace_distribution['zone2'] = distribution_buckets[1].time
    pace_distribution['zone3'] = distribution_buckets[2].time
    pace_distribution['zone4'] = distribution_buckets[3].time
    pace_distribution['zone5'] = distribution_buckets[4].time
    pace_distribution['zone6'] = distribution_buckets[5].time
    pace_distribution
  end

  def save_activity_zone(zones,activity_id,type)
    az = ActivityZone.new
    az.aid = activity_id.to_s
    az.type = type
    az.zone1 = zones['zone1']
    az.zone2 = zones['zone2']
    az.zone3 = zones['zone3']
    az.zone4 = zones['zone4']
    az.zone5 = zones['zone5']
    az.zone6 = zones['zone6']
    az.user  = current_user
    az.save
  end
end
