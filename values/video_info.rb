# frozen_string_literal: true

#VideoInfo = Struct.new :video_id, :title, :description, :view_count,
#                       :like_count, :dislike_count, :duration
class VideoInfo
  attr_accessor :id, :video_id, :title, :description, :view_count, :like_count,
                :dislike_count, :duration, :last_update_time

  def initialize(id: nil, video_id: nil, title: nil, description: nil,
                 view_count: nil, like_count:nil, dislike_count: nil,
                 duration: nil, last_update_time: nil)
    @id = id
    @video_id = video_id
    @title = title
    @description = description
    @view_count = view_count
    @like_count = like_count
    @dislike_count = dislike_count
    @duration = duration
    @last_update_time = last_update_time
  end
end
