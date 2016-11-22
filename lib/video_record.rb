# frozen_string_literal: true

# Video record management
class VideoRecord
  # Create new video record
  def self.create(video_info)
    created_video = Video.create(
      video_id:         video_info.video_id,
      title:            video_info.title,
      description:      video_info.description,
      view_count:       video_info.view_count,
      like_count:       video_info.like_count,
      dislike_count:    video_info.dislike_count,
      duration:         video_info.duration,
      last_update_time: Time.now
    )
  end

  # Find video record
  def self.find(video_info)
    columns = [:id, :video_id, :title, :description, :view_count, :like_count,
               :dislike_count, :duration]
    results = Video.where()
    columns.each do |col|
      val = video_info.send(col)
      results = results.where(col => val) unless val.nil?
    end
    results.first
  end

  # Update existed video record
  def self.update(id, video_info)
    video = Video.find(id: id)

    columns = [:video_id, :title, :description, :view_count, :like_count,
               :dislike_count, :duration]
    columns.each do |col|
      val = video_info.send(col)
      video.send("#{col}=", video_info.send(col)) unless val.nil?
    end

    video.last_update_time = Time.now
    video.save
  end
end
