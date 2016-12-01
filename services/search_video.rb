# frozen_string_literal: true

# Search video info from database
class SearchVideo
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :update_to_latest, lambda { |params|
    video_id = params[:video_id]
    success = Update2LatestQuery.call(video_id)
    if success
      Right(video_id: video_id)
    else
      Left(Error.new(:bad_request,
           "Video (video_id: #{params[:video_id]}) could not be found"))
    end
  }

  register :get_video_info, lambda { |input|
    video_id = input[:video_id]
    video = Video.find(video_id: video_id)
    if video
      Right(video: video)
    else
      Left(Error.new(:not_found, "Video (video_id: #{video_id}) not found"))
    end
  }

  register :render_search_result, lambda { |input|
    results = VideoInfo.new(
      video_id:            input[:video].video_id,
      title:               input[:video].title,
      description:         input[:video].description,
      view_count:          input[:video].view_count,
      like_count:          input[:video].like_count, 
      dislike_count:       input[:video].dislike_count,
      duration:            input[:video].duration,
      channel_title:       input[:video].channel_title,
      channel_description: input[:video].channel_description,
      channel_image_url:   input[:video].channel_image_url
    )
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :update_to_latest # update existed record or load new record
      step :get_video_info
      step :render_search_result
    end.call(params)
  end
end
