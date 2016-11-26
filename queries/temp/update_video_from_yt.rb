# frozen_string_literal: true

# Update an existed video and its downstream data in the database
class UpdateVideoFromYTQuery
  def self.call(id, latest_video)
    # id: id of video model; latest_video: Video object from YPBT
    begin
      update_video_record(id, latest_video)
      success = true
    rescue
      success = false
    end
  end

  def self.update_video_record(id, latest_video)
    video_info = VideoInfo.new(
      title:         latest_video.title,
      description:   latest_video.description,
      view_count:    latest_video.view_count,
      like_count:    latest_video.like_count,
      dislike_count: latest_video.dislike_count,
      duration:      latest_video.duration
    )
    VideoRecord.update(id, video_info)

    latest_comments = latest_video.comments
    latest_comments.each do |latest_comment|
      comment = Comment.find(video_id: id,
                             comment_id: latest_comment.comment_id)
      if comment.nil?
        CreateVideoFromYT.create_comment_record(id, latest_comment)
      else
        update_comment_record(comment.id, latest_comment)
      end
    end
  end

  def self.update_comment_record(id, latest_comment)
    comment_info = CommentInfo.new(
      published_at: latest_comment.published_at,
      updated_at:   latest_comment.updated_at ?
                    latest_comment.updated_at : "",
      text_display: latest_comment.text_display,
      like_count:   latest_comment.like_count
    )
    CommentRecord.update(id, comment_info)

    latest_timetags = latest_comment.time_tags
    latest_timetags.each do |latest_timetag|
      timetag = Timetag.find(comment_id: id,
                             start_time: latest_timetag.start_time)
      if timetag.nil?
        CreateVideoFromYT.create_timetag_record(id, latest_timetag)
      else
        update_timetag_record(timetag.id, latest_timetag)
      end
    end

    latest_author = latest_comment.author
    author = Author.find(comment_id: id)
    update_author_record(author.id, latest_author)
  end

  def self.update_timetag_record(id, latest_timetag)
    timetag_info = TimetagInfo.new(
      yt_like_count: latest_timetag.like_count
    )
    TimetagRecord.update(id, timetag_info)
  end

  def self.update_author_record(id, latest_author)
    author_info = AuthorInfo.new(
      author_name:        latest_author.author_name,
      author_image_url:   latest_author.author_image_url,
      author_channel_url: latest_author.author_channel_url,
      like_count:         latest_author.like_count
    )
    AuthorRecord.update(id, author_info)
  end
end
