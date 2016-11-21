# frozen_string_literal: true

# Create a new video and its downstream data in the database using YPBT gem
class CreateVideoFromYT
  def self.call(video)
    # video: Video object from YPBT
    begin
      create_video_record(video)
      success = true
    rescue
      success = false
    end
  end

  def self.create_video_record(video)
    video_info = VideoInfo.new(
      video_id:      video.id,
      title:         video.title,
      description:   video.description,
      view_count:    video.view_count,
      like_count:    video.like_count,
      dislike_count: video.dislike_count,
      duration:      video.duration
    )
    created_video = VideoRecord.create(video_info)
    
    video.comments.each do |comment|
      create_comment_record(created_video.id, comment)
    end
  end

  def self.create_comment_record(video_id, comment)
    comment_info = CommentInfo.new(
      video_id:     video_id,
      comment_id:   comment.comment_id,
      published_at: comment.published_at,
      updated_at:   (comment.updated_at ? comment.updated_at : ""),
      text_display: comment.text_display,
      like_count:   comment.like_count
    )
    created_comment = CommentRecord.create(comment_info)
    
    comment.time_tags.each do |timetag|
      create_timetag_record(created_comment.id, timetag)
    end
    
    create_author_record(created_comment.id, comment.author)
  end

  def self.create_timetag_record(comment_id, timetag)
    timetag_info = TimetagInfo.new(
      comment_id:     comment_id,
      yt_like_count:  timetag.like_count,
      our_like_count: 0,
      start_time:     timetag.start_time
    )
    created_timetag = TimetagRecord.create(timetag_info)
  end

  def self.create_author_record(comment_id, author)
    author_info = AuthorInfo.new(
      comment_id:         comment_id,
      author_name:        author.author_name,
      author_image_url:   author.author_image_url,
      author_channel_url: author.author_channel_url,
      like_count:         author.like_count
    )
    created_author = AuthorRecord.create(author_info)
  end
end
