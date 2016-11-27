# frozen_string_literal: true

# Update an existed video and its downstream data in the database
class GetCommentAuthorInfoQuery
  def self.call(comment_id)
    comment_info  = CommentInfo.new(comment_id: comment_id)
    comment_found = CommentRecord.find(comment_info)
    author_info   = AuthorInfo.new(comment_id: comment_found.id)
    author_found  = AuthorRecord.find(author_info)
  end
end
