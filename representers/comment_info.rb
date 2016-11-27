# frozen_string_literal: true

# Represents overall comment information for JSON API output
class CommentInfoRepresenter < Roar::Decorator
  include Roar::JSON

  property :video_id
  property :comment_id
  property :text_display
  property :like_count
  property :author_name
  property :author_image_url
  property :author_channel_url
end
