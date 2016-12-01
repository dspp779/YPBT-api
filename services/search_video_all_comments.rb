# frozen_string_literal: true

# Get all comments' info of one assigned video from database
class SearchVideoAllComments
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

  register :get_video_all_comments, lambda { |input|
    video_id = input[:video_id]
    comments = GetVideoAllCommentsQuery.call(video_id)
    if comments
      results = comments
      Right(results)
    else
      Left(Error.new(:not_found, "Video (video_id: #{video_id}) not found"))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :update_to_latest # update existed record or load new record
      step :get_video_all_comments
    end.call(params)
  end
end