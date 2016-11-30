# frozen_string_literal: true

#TimetagInfo = Struct.new :comment_id, :yt_like_count, :our_like_count,
#                         :start_time
class TimetagInfo
  attr_accessor :id, :comment_id, :yt_like_count, :our_like_count,
                :our_unlike_count, :start_time, :end_time, :tag_type,
                :start_time_percentage, :end_time_percentage

  def initialize(id: nil, comment_id: nil, yt_like_count: nil,
                 our_like_count: nil, our_unlike_count: nil, start_time: nil,
                 end_time: nil, tag_type: nil, start_time_percentage: nil,
                 end_time_percentage: nil)
    @id = id
    @comment_id = comment_id
    @yt_like_count = yt_like_count
    @our_like_count = our_like_count
    @our_unlike_count = our_unlike_count
    @start_time = start_time
    @end_time = end_time
    @tag_type = tag_type
    @start_time_percentage = start_time_percentage
    @end_time_percentage = end_time_percentage
  end
end
