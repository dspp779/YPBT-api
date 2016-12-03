# frozen_string_literal: true

class CompleteRecord
  attr_accessor :video_info, :comment_info, :timetag_info, :author_info

  def initialize(video_info: nil, comment_info: nil, timetag_info: nil,
                 author_info: nil)
    @video_info = video_info
    @comment_info = comment_info
    @timetag_info = timetag_info
    @author_info = author_info

    @video_info = VideoInfo.new() if @video_info.nil?
    @comment_info = CommentInfo.new() if @comment_info.nil?
    @timetag_info = TimetagInfo.new() if @timetag_info.nil?
    @author_info = AuthorInfo.new() if @author_info.nil?
  end

  def set_video_duration_from_iso8601(iso8601_string)
    duration = Duration.new(iso8601_string)
    @video_info.duration = duration.total
  end

  def set_timetag_start_time_from_iso8601(iso8601_string)
    duration = Duration.new(iso8601_string)
    @timetag_info.start_time = duration.total
  end

  def set_timetag_end_time_from_iso8601(iso8601_string)
    duration = Duration.new(iso8601_string)
    @timetag_info.end_time = duration.total
  end

  def set_timetag_start_time_percentage()
    unless @video_info.duration.nil?
      @timetag_info.start_time_percentage =
        (@timetag_info.start_time.to_f / @video_info.duration.to_f).round(3)
    else
      nil
    end
  end

  def set_timetag_end_time_percentage()
    unless @video_info.duration.nil?
      @timetag_info.end_time_percentage =
        (@timetag_info.end_time.to_f / @video_info.duration.to_f).round(3)
    else
      nil
    end
  end
end
