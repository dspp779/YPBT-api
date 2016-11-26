# frozen_string_literal: true

#TimetagInfo = Struct.new :comment_id, :yt_like_count, :our_like_count,
#                         :start_time
class TimetagInfo
  attr_accessor :id, :comment_id, :yt_like_count, :our_like_count,
                :start_time

  def initialize(id: nil, comment_id: nil, yt_like_count: nil,\
                 our_like_count: nil, start_time: nil)
    @id = id
    @comment_id = comment_id
    @yt_like_count = yt_like_count
    @our_like_count = our_like_count
    @start_time = start_time
  end
end
