# frozen_string_literal: true

# Loads data from YT video to database
class SearchVideos
  extend Dry::Monads::Either::Mixin

  def self.call
    videos_found = VideoRecord.get_all_videos
    if videos_found.nil?
      Left(Error.new(:not_found, 'No Videos found'))
    else
      Right(videos_found)
    end
  end
end
