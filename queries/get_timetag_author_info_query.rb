# frozen_string_literal: true

# Get the author where the input timetag belongs in the database
class GetTimetagAuthorInfoQuery
  def self.call(timetag_id)
    timetag_info  = TimetagInfo.new(id: timetag_id)
    timetag_found = TimetagRecord.find(timetag_info)
    comment_info  = CommentInfo.new(id: timetag_found.comment_id)
    comment_found = CommentRecord.find(comment_info)
    author_info   = AuthorInfo.new(comment_id: comment_found.id)
    author_found  = AuthorRecord.find(author_info)
  end
end
