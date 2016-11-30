# frozen_string_literal: true

class YPBTParser
  def self.call(video)
    arrayOfRecord = parse_video(video)
  end

  def self.parse_video(video)
    arrayOfRecord = []
    video.comments.each do |comment|
      arrayOfRecord.concat parse_comment(comment)
    end
    arrayOfRecord = arrayOfRecord.map do |record|
      fill_in_video_info(record, video)
      record.set_timetag_start_time_percentage()
      record
    end
  end

  def self.parse_comment(comment)
    arrayOfRecord = comment.time_tags.map do |timetag|
      record = CompleteRecord.new()
      fill_in_timetag_info(record, timetag)
    end
    arrayOfRecord = arrayOfRecord.map do |record|
      fill_in_comment_info(record, comment)
      fill_in_author_info(record, comment.author)
    end
  end

  def self.fill_in_video_info(record, video)
    record.video_info.video_id      = video.id
    record.video_info.title         = video.title
    record.video_info.description   = video.description
    record.video_info.view_count    = video.view_count
    record.video_info.like_count    = video.like_count
    record.video_info.dislike_count = video.dislike_count
    record.set_video_duration_from_iso8601(video.duration)
    record
  end

  def self.fill_in_comment_info(record, comment)
    record.comment_info.comment_id   = comment.comment_id
    record.comment_info.published_at = comment.published_at
    record.comment_info.updated_at   = comment.updated_at \
                                       unless comment.updated_at.nil?
    record.comment_info.text_display = comment.text_display
    record.comment_info.like_count   = comment.like_count
    record
  end

  def self.fill_in_timetag_info(record, timetag)
    record.timetag_info.yt_like_count  = timetag.like_count
    record.timetag_info.our_like_count = 0
    record.timetag_info.our_unlike_count = 0
    record.set_timetag_start_time_from_iso8601(timetag.start_time)
    record
  end

  def self.fill_in_author_info(record, author)
    record.author_info.author_name        = author.author_name
    record.author_info.author_image_url   = author.author_image_url
    record.author_info.author_channel_url = author.author_channel_url
    record.author_info.like_count         = author.like_count
    record
  end
end
