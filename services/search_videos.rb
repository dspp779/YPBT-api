# frozen_string_literal: true

# Loads data from YT video to database
class SearchVideos
  extend Dry::Monads::Either::Mixin

  def self.call
    if (videos = Video.all).nil?
      Left(Error.new(:not_found, 'No Videos found'))
    else
      Right(Videos.new(videos))
    end
  end
end
