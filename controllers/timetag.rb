# frozen_string_literal: true

# YPBT-API web service
class YPBT_API < Sinatra::Base
  #YT_URL_REGEX = %r{https://www.youtube.com/watch\?v=(\S[^&]+)}

  # Get timetag info from database
  # tux: get 'api/v0.1/TimeTag/:timetag_id'
  get "/#{API_VER}/TimeTag/:timetag_id/?" do
    results = SearchTimetag.call(params)

    if results.success?
      TimetagInfoRepresenterA.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # Get all timetags' info of one assigned video from database
  # tux: get 'api/v0.1/TimeTags/:video_id'
  get "/#{API_VER}/TimeTags/:video_id" do
    results = SearchVideoAllTimetags.call(params)

    if results.success?
      TimetagInfoThreadRepresenter.new(results.value).to_json
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
=end
  # Add like count for the tag
  # tux: put 'api/v0.1/TimeTag/add_one_like',
  #   { time_tag_id: "timetag_id" }.to_json,
  #   'CONTENT_TYPE' => 'application/json'
  put "/#{API_VER}/TimeTag/add_one_like/?" do
    results = TimetagAddOneLike.call(request)

    if results.success?
      ApiInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # Add unlike count for the tag
  # tux: put 'api/v0.1/TimeTag/add_one_unlike',
  #   { time_tag_id: "timetag_id" }.to_json,
  #   'CONTENT_TYPE' => 'application/json'
  put "/#{API_VER}/TimeTag/add_one_unlike/?" do
    results = TimetagAddOneUnlike.call(request)

    if results.success?
      ApiInfoRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
