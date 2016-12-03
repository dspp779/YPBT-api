# frozen_string_literal: true

# Add new timetag
class AddNewTimetag
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :api_key_authenticate, lambda { |request|
    body_params = JSON.parse request.body.read
    api_key = body_params['api_key']

    if api_key == ENV['YOUTUBE_API_KEY']
      params = body_params
      Right(params)
    else
      Left(Error.new(:forbidden, "Authentication fail"))
    end
  }

  register :check_video, lambda { |params|
    video_id = params['video_id']
    video_info = VideoInfo.new(video_id: video_id)
    video_found = VideoRecord.find(video_info)

    if video_found.nil?
      video_raw = YoutubeVideo::Video.find(video_id: video_id)
      video_record = YPBTParserVideoOnly.call(video_raw).first
      video_found = video_record.video_info
    end

    unless video_found.nil?
      Right(video_info: video_found, params: params)
    else
      Left(Error.new(:bad_request, 
        "Video (video_id: #{video_id}) is not available"))
    end
  }

  register :add_new_timetag, lambda { |input|
    success = AddNewTimetagQuery.call(input[:video_info], input[:params])

    if success
      Right(input[:params])
    else
      Left(Error.new(:internal_error,
        "Cannot add new time_tag in choosed video " +
        "(video_id: #{params['video_id']})"))
    end
  }

  register :render_api_info, lambda { |params|
    results = ApiInfo.new("Add new time_tag in choosed video " +
                          "(video_id: #{params['video_id']})")
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :api_key_authenticate
      step :check_video # is already stored in database
      step :add_new_timetag
      step :render_api_info
    end.call(params)
  end
end
