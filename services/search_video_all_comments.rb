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
    comments = fill_in_comments_author_data(comments)
    comments = modified_video_dbid_to_yt_video_id(video_id, comments)
    if comments
      results = comments
      Right(results)
    else
      Left(Error.new(:not_found, "No record existed (video_id: #{video_id})"))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :update_to_latest # update existed record or load new record
      step :get_video_all_comments
    end.call(params)
  end

  def self.fill_in_comments_author_data(comments)
    comments.each do |comment_info|
      author_info  = AuthorInfo.new(comment_id: comment_info.id)
      author_found = AuthorRecord.find(author_info)
      comment_info.author_name = author_found.author_name
      comment_info.author_image_url = author_found.author_image_url
      comment_info.author_channel_url = author_found.author_channel_url
    end
  end

  def self.modified_video_dbid_to_yt_video_id(yt_video_id, comments)
    comments.each do |comment_info|
      comment_info.video_id = yt_video_id
    end
  end
end
