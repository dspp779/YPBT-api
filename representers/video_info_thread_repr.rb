# frozen_string_literal: true
require_relative 'video_info_repr'

# Represents all videos information for JSON API output
class VideoInfoThreadRepresenter
  def initialize(videos)
    @videos = videos.map do |video|
      JSON.parse(VideoInfoRepresenter.new(video).to_json)
    end
  end

  def to_json
    @videos.to_json
  end
end

=begin
class VideosRepresenter < Roar::Decorator
  include Roar::JSON

  collection :videos, extend: VideoInfoRepresenter, class: Video
end
=end
