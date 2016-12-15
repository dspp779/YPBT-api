# frozen_string_literal: true

# fill popular videos info from YPBT-gem data
class FillPopVideosInfoQuery
  def self.call(videos_pop)
    videos_pop_info = videos_pop.map do |video_pop|
      video_pop_info = VideoPopInfo.new(
        video_id:      video_pop.id,
        title:         video_pop.title,
        channel_id:    video_pop.channel_id,
        channel_title: video_pop.channel_title,
        view_count:    video_pop.view_count,
        like_count:    video_pop.like_count,
        thumbnail_url: video_pop.thumbnail_url
      )
    end
  end
end
