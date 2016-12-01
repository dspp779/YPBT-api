# frozen_string_literal: true

# Represents overall video information for JSON API output
class VideoInfoRepresenter < Roar::Decorator
  include Roar::JSON

  property :video_id
  property :title
  property :description
  property :view_count
  property :like_count
  property :dislike_count
  property :duration
  property :channel_title, render_nil: true
  property :channel_description, render_nil: true
  property :channel_image_url, render_nil: true
end
