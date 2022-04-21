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
        print("\n\nRedirecting stale token...\n\n")
        return nil
      end
    end
  end
end
