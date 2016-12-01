# frozen_string_literal: true
require_relative 'video_info_repr'

# Represents overall group information for JSON API output
class VideosRepresenter < Roar::Decorator
  include Roar::JSON

  collection :videos, extend: VideoInfoRepresenter, class: Video
end
