# frozen_string_literal: true

# Get the video where the input commend belongs in the database
class GetCommentVideoInfoQuery
  def self.call(comment_id)
    comment_info  = CommentInfo.new(comment_id: comment_id)
    comment_found = CommentRecord.find(comment_info)
    video_info   = VideoInfo.new(id: comment_found.video_id)
    video_found  = VideoRecord.find(video_info)
  end
end
