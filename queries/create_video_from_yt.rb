# frozen_string_literal: true

# Create a new video and its downstream data in the database using YPBT gem
class CreateVideoFromYTQuery
  def self.call(video)
    # video: Video object from YPBT
    begin
      CreateRecordFromYT.create_video_record(video)
      success = true
    rescue
      success = false
    end
  end
end
