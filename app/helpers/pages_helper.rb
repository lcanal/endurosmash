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
    begin
      activities_ids = activities.map { |a| a.id }
      missing_ids = find_missing_ids(activities_ids)
      ActivityZone.where
      activities.each do |activity|
        # ActivityZone.where
        # client = Strava::Api::Client.new(access_token: session[:access_token])
        zones = client.activity_zones(activity.id)
        zones.each do |zone|
          if (zone.include? 'type') && (zone.type == "pace")
            distribution_buckets = zone.distribution_buckets
            pace_zones << get_distribution_buckets(distribution_buckets)
          end
        end
      end
    rescue Strava::Errors::Fault => e
      print(e.headers)
      if e.headers["status"] == "401 Unauthorized"
        zones = nil
      end
    end
    pace_zones
  end

  def find_missing_ids(missing_ids)
    found = ActivityZone.where("sid in (?)", missing_ids.join('",'))
    print("I found #{found}")
    ActivityZone.where
  end

  def get_distribution_buckets(distribution_buckets)
    pace_distribution = {}
    pace_distribution['z1'] = distribution_buckets[0]
    pace_distribution['z2'] = distribution_buckets[1]
    pace_distribution['z3'] = distribution_buckets[2]
    pace_distribution['z4'] = distribution_buckets[3]
    pace_distribution['z5'] = distribution_buckets[4]
    pace_distribution
  end
end
