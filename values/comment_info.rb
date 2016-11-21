# frozen_string_literal: true

#CommentInfo = Struct.new :video_id, :comment_id, :published_at, :updated_at,
#                         :text_display, :like_count
class CommentInfo
  attr_accessor :video_id, :comment_id, :published_at, :updated_at,
                :text_display, :like_count

  def initialize(video_id: nil, comment_id: nil, published_at: nil,
                 updated_at: nil, text_display: nil, like_count: nil)
    @video_id = video_id
    @comment_id = comment_id
    @published_at = published_at
    @updated_at = updated_at
    @text_display = text_display
    @like_count = like_count
  end
end
