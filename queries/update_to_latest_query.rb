# frozen_string_literal: true

# update existed record or load new record
class Update2LatestQuery
  COOLDOWN_TIME = 600 # second  

  def self.call(video_id)
    begin
      update_to_latest(video_id)
      success = true
    rescue
      success = false
    end
  end

  def self.update_to_latest(video_id)
    video_info   = VideoInfo.new(video_id: video_id)
    video_found  = VideoRecord.find(video_info)

    unless video_found.nil?
      update_video(video_found)
    else
      create_video(video_id)
    end
  end

  def self.update_video(video_found)
    unless within_cd(video_found)
      refresh_last_update_time_beforehand(video_found.id)
      latest_video = YoutubeVideo::Video.find(video_id: video_found.video_id)
      arrayOfRecord = YPBTParser.call(latest_video)
      RefreshDatabase.call(arrayOfRecord)
      #UpdateRecordFromYT.update_video_record(video_found.id, latest_video)
    else
    end
  end

  def self.create_video(video_id)
    new_video = YoutubeVideo::Video.find(video_id: video_id)
    arrayOfRecord = YPBTParser.call(new_video)
    RefreshDatabase.call(arrayOfRecord)
    #CreateRecordFromYT.create_video_record(new_video)
  end

  def self.within_cd(video_found)
    time_diff = (Time.now - video_found.last_update_time).to_i

    if time_diff < COOLDOWN_TIME
      true
    else
      false
    end
  end

  def self.refresh_last_update_time_beforehand(id)
    # Refresh the last_update_time for a video record; used when beforehand
    # refreshment of the last_update_time of one video is needed before its 
    # real update
    video_info = VideoInfo.new()
    updated_video = VideoRecord.update(id, video_info)
  end
end
