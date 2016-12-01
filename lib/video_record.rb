# frozen_string_literal: true

# Video record management
class VideoRecord
  # Create new video record
  def self.create(video_info)
    created_video = Video.create(
      video_id:            video_info.video_id,
      title:               video_info.title,
      description:         video_info.description,
      view_count:          video_info.view_count,
      like_count:          video_info.like_count,
      dislike_count:       video_info.dislike_count,
      duration:            video_info.duration,
      channel_title:       video_info.channel_title,
      channel_description: video_info.channel_description,
      channel_image_url:   video_info.channel_image_url,
      last_update_time: Time.now
    )
  end

  # Find video record
  def self.find(video_info)
    columns = [:id, :video_id, :title, :description, :view_count, :like_count,
               :dislike_count, :duration, :channel_title, :channel_description,
               :channel_image_url, :last_update_time]
    results = Video.where()
    columns.each do |col|
      val = video_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    unless results.first.nil?
      video_found = VideoInfo.new(
        id: results.first.id,
        video_id: results.first.video_id,
        title: results.first.title,
        description: results.first.description,
        view_count: results.first.like_count,
        dislike_count: results.first.dislike_count,
        duration: results.first.duration,
        channel_title: results.first.channel_title,
        channel_description: results.first.channel_description,
        channel_image_url: results.first.channel_image_url,
        last_update_time: results.first.last_update_time
      )
    else
      nil
    end
  end

  # Update existed video record
  def self.update(id, video_info)
    video = Video.find(id: id)

    columns = [:video_id, :title, :description, :view_count, :like_count,
               :dislike_count, :channel_title, :channel_description,
               :channel_image_url, :duration]
    columns.each do |col|
      val = video_info.send(col)
      video.send("#{col}=", video_info.send(col)) unless val.nil?
    end

    video.last_update_time = Time.now
    video.save
  end
end
