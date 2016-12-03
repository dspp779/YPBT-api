# frozen_string_literal: true

# Get all timetags' info of one assigned video from database
class GetVideoAllTimetagsQuery
  def self.call(video_id)
    video_info     = VideoInfo.new(video_id: video_id)
    video_found    = VideoRecord.find(video_info)
    unless video_found.nil?
      comments_found = find_all_comments(video_found)
      timetags_found = find_all_timetags(comments_found)
    end
  end

  def self.find_all_comments(video_found)
    comment_info   = CommentInfo.new(video_id: video_found.id)
    comments_found = CommentRecord.find_all(comment_info)
  end

  def self.find_all_timetags(comments_found)
    timetags_collection = comments_found.map do |comment_found|
      timetag_info   = TimetagInfo.new(comment_id: comment_found.id)
      timetags_found = TimetagRecord.find_all(timetag_info)
    end
    timetags_collection.flatten
  end
end
