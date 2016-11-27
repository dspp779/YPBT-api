# frozen_string_literal: true

# Update an existed video and its downstream data in the database
class UpdateVideoFromYTQuery
  def self.call(id, latest_video)
    # id: id of video model; latest_video: Video object from YPBT
    begin
      UpdateRecordFromYT.update_video_record(id, latest_video)
      success = true
    rescue
      success = false
    end
  end
end
