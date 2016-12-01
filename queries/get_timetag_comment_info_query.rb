# frozen_string_literal: true

# Get the comment where the input timetag belongs in the database
class GetTimetagCommentInfoQuery
  def self.call(timetag_id)
    timetag_info  = TimetagInfo.new(id: timetag_id)
    timetag_found = TimetagRecord.find(timetag_info)
    comment_info  = CommentInfo.new(id: timetag_found.comment_id)
    comment_found = CommentRecord.find(comment_info)
  end
end
