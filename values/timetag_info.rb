# frozen_string_literal: true

#TimetagInfo = Struct.new :comment_id, :yt_like_count, :our_like_count,
#                         :start_time
class TimetagInfo
  attr_accessor :id, :comment_id, :yt_like_count, :our_like_count,
                :our_dislike_count, :start_time, :end_time, :tag_type,
                :start_time_percentage, :end_time_percentage, :text_display,
                :author_name, :author_image_url, :author_channel_url

  def initialize(id: nil, comment_id: nil, yt_like_count: nil,
                 our_like_count: nil, our_dislike_count: nil, start_time: nil,
                 end_time: nil, tag_type: nil, start_time_percentage: nil,
                 end_time_percentage: nil, text_display: nil, author_name: nil,
                 author_image_url: nil, author_channel_url: nil)
    @id = id
    @comment_id = comment_id
    @yt_like_count = yt_like_count
    @our_like_count = our_like_count
    @our_dislike_count = our_dislike_count
    @start_time = start_time
    @end_time = end_time
    @tag_type = tag_type
    @start_time_percentage = start_time_percentage
    @end_time_percentage = end_time_percentage
    @text_display = text_display # comment model
    @author_name = author_name # author model
    @author_image_url = author_image_url # author model
    @author_channel_url = author_channel_url # author model
  end
end
