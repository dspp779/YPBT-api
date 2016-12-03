# frozen_string_literal: true

# Get all comments' info of one assigned video from database
class GetVideoAllCommentsQuery
  def self.call(video_id)
    video_info     = VideoInfo.new(video_id: video_id)
    video_found    = VideoRecord.find(video_info)
    unless video_found.nil?
      comment_info   = CommentInfo.new(video_id: video_found.id)
      comments_found = CommentRecord.find_all(comment_info)
    end
  end
end
