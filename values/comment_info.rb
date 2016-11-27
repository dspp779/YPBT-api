# frozen_string_literal: true

#CommentInfo = Struct.new :video_id, :comment_id, :published_at, :updated_at,
#                         :text_display, :like_count
class CommentInfo
  attr_accessor :id, :video_id, :comment_id, :published_at, :updated_at,
                :text_display, :like_count, :author_name, :author_image_url,
                :author_channel_url

  def initialize(id: nil, video_id: nil, comment_id: nil, published_at: nil,
                 updated_at: nil, text_display: nil, like_count: nil,
                 author_name: nil, author_image_url: nil,
                 author_channel_url: nil)
    @id = id
    @video_id = video_id
    @comment_id = comment_id
    @published_at = published_at
    @updated_at = updated_at
    @text_display = text_display
    @like_count = like_count
    @author_name = author_name
    @author_image_url = author_image_url
    @author_channel_url = author_channel_url
  end
end
