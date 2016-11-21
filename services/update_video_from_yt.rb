# frozen_string_literal: true

# Update an existed video and its downstream data in the database
class UpdateVideoFromYT
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  COOLDOWN_TIME = 10 # second

  register :check_video, lambda { |params|
    video_id = params[:video_id]
    video = Video.find(video_id: video_id)

    unless video.nil?
      Right(video: video)
    else
      Left(Error.new(:bad_request, 
        "Video (video_id: #{video_id}) is not stored"))
    end
  }

  register :check_cd_time, lambda { |input|
    time_diff = (Time.now - input[:video].last_update_time).to_i

    unless time_diff < COOLDOWN_TIME
      Right(video: input[:video])
    else
      Left(Error.new(:OK, "Already update to lastest"))
    end
  }

  register :fetch_video_data, lambda { |input|
    latest_video = YoutubeVideo::Video.find(video_id: input[:video].video_id)

    if latest_video
      Right(video: input[:video], latest_video: latest_video)
    else
      Left(Error.new(:not_found,
        "Video (video_id: #{video_id}) not found on Youtube"))
    end
  }

  register :update_video_record, lambda { |input|
    success = UpdateVideoFromYTQuery.call(input[:video].id,
                                          input[:latest_video])

    if success
      Right(1)
    else
      Left(Error.new(:internal_error,
        "Cannot update posting (id: #{input[:video].video_id})"))
    end
  }

  register :render_api_info, lambda { |input|
    results = ApiInfo.new("Update to lastest")
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :check_video # is already stored in database
      step :check_cd_time # has come to zero
      step :fetch_video_data
      step :update_video_record # and its downstream data
      step :render_api_info
    end.call(params)
  end
end
