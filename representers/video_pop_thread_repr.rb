# frozen_string_literal: true

# Represents collected pop videos' information as thread for JSON API output
class VideoPopThreadRepresenter
  def initialize(videos_pop_info)
    @video_pop_thread = videos_pop_info.map do |video_pop_info|
      JSON.parse(VideoPopRepresenter.new(video_pop_info).to_json)
    end
  end

  def to_json
    @video_pop_thread.to_json
  end
end
