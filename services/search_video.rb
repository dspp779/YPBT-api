# frozen_string_literal: true

# Search video info from YPBT gem
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
    video_info = Video.find(video_id: video_id)
    video_info = fetch_video_from_YPBTgem(video_id) if video_info.nil?

    unless video_info.nil?
      Right(video_info: video_info)
    else
      Left(Error.new(:not_found, "Video (video_id: #{video_id}) not found"))
    end
  }

  register :render_search_result, lambda { |input|
    Right(input[:video_info])
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      #step :update_to_latest # update existed record or load new record
      step :get_video_info
      step :render_search_result
    end.call(params)
  end

  def self.fetch_video_from_YPBTgem(video_id)
    video = YoutubeVideo::Video.find(video_id: video_id)
    unless video.nil?
      arrayOfRecord = YPBTParserVideoOnly.call(video)
      video_info = arrayOfRecord.first.video_info
    else
      nil
    end
  end
end
