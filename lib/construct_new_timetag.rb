# frozen_string_literal: true

class ConstructNewTimetag
  def self.call(video_info:, start_time:, end_time: nil, tag_type:,
                comment_text_display:)
    record = CompleteRecord.new(video_info: video_info)

    record.comment_info.comment_id = ""
    record.comment_info.text_display = comment_text_display
    record.comment_info.like_count = 0

    record.timetag_info.click_count = 0
    record.timetag_info.yt_like_count = 0
    record.timetag_info.our_like_count = 0
    record.timetag_info.our_dislike_count = 0
    record.timetag_info.tag_type = tag_type
    record.set_timetag_start_time_from_iso8601(start_time)
    record.set_timetag_start_time_percentage()
    record.set_timetag_end_time_from_iso8601(end_time) unless end_time.nil?
    record.set_timetag_end_time_percentage() unless end_time.nil?

    record.author_info.author_name = "anonymous"
    record.author_info.author_image_url = "https://yt3.ggpht.com/-RldWIErYqmw/AAAAAAAAAAI/AAAAAAAAAAA/fwy7skAJauU/s48-c-k-no-mo-rj-c0xffffff/photo.jpg"
    record.author_info.author_channel_url = ""
    record.author_info.like_count = 0

    record
  end
end
