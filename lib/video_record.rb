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

  # Update existed video record
  def self.update(id, video_info)
    video = Video.find(id: id)

    unless video_info.video_id.nil?
      video.video_id = video_info.video_id
    end

    unless video_info.title.nil?
      video.title = video_info.title
    end

    unless video_info.description.nil?
      video.description = video_info.description
    end

    unless video_info.view_count.nil?
      video.view_count = video_info.view_count
    end

    unless video_info.like_count.nil?
      video.like_count = video_info.like_count
    end

    unless video_info.dislike_count.nil?
      video.dislike_count = video_info.dislike_count
    end

    unless video_info.duration.nil?
      video.duration = video_info.duration
    end

    video.last_update_time = Time.now
    video.save
  end
end
