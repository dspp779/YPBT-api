# frozen_string_literal: true

class VideoPopInfo
  attr_accessor :video_id, :title, :channel_id, :channel_title, :view_count,
                :like_count, :thumbnail_url

  def initialize(video_id: nil, title: nil, channel_id: nil,
                 channel_title: nil, view_count: nil, like_count:nil,
                 thumbnail_url: nil)
    @video_id = video_id
    @title = title
    @channel_id = channel_id
    @channel_title = channel_title
    @view_count = view_count
    @like_count = like_count
    @thumbnail_url = thumbnail_url
  end
end
