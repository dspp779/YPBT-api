# frozen_string_literal: true

# add new TimeTag
class AddNewTimetagQuery
  def self.call(video_info, params)
    begin
      start_time = params['start_time']
      end_time = params['end_time'] unless params['end_time'] == nil
      tag_type = params['tag_type']
      comment_text_display = params['comment_text_display']

      record = ConstructNewTimetag.call(
        video_info:           video_info,
        start_time:           start_time,
        end_time:             end_time,
        tag_type:             tag_type,
        comment_text_display: comment_text_display
      )

      arrayOfRecord = 1.times.map { record }
      RefreshDatabase.call(arrayOfRecord)

      success = true
    rescue
      success = false
    end
  end
end
