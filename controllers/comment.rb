# frozen_string_literal: true

# YPBT-API web service
class YPBT_API < Sinatra::Base
  #YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}
  #COOLDOWN_TIME = 10 # second

=begin
  # Get comment info from database
  get "/#{API_VER}/video/?" do
    results = SearchVideos.call
    VideosRepresenter.new(results.value).to_json
  end
=end

  # Get comment info from database
  # tux: get 'api/v0.1/comment/:comment_id'
  get "/#{API_VER}/Comment/:comment_id/?" do
    results = SearchComment.call(params)

    if results.success?
      CommentInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

=begin
  # get all tagid for this video
  get "/#{API_VER}/video/:video_id/get_all_tagid?" do
    content_type 'application/json'
    ["Need Implement"].to_json
  end

  # Create a new video and its downstream data in the database
  # tux: post 'api/v0.1/video', { url: "youtube_url" }.to_json, 
  #                             'CONTENT_TYPE' => 'application/json'
  post "/#{API_VER}/video/?" do
    results = LoadVideoFromYT.call(request)

    if results.success?
      VideoInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # Update whole record of an existed video in the database
  # tux: put 'api/v0.1/video/:video_id'
  put "/#{API_VER}/video/:video_id/?" do
    results = UpdateVideoFromYT.call(params)

    if results.success?
      #{ status: 'OK', message: "Update to lastest" }.to_json
      ApiInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
=end
end
