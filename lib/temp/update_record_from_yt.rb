# frozen_string_literal: true

# Update an existed video and its downstream data in the database
class UpdateRecordFromYT
  def self.update_video_record(id, latest_video)
    video_updator(id, latest_video)

    latest_comments = latest_video.comments
    latest_comments.each do |latest_comment|
      comment = find_comment_record(id, latest_comment)
      if comment.nil?
        CreateRecordFromYT.create_comment_record(id, latest_comment)
      else
        update_comment_record(comment.id, latest_comment)
      end
    end
  end

  def self.update_comment_record(id, latest_comment)
    comment_updator(id, latest_comment)

    latest_timetags = latest_comment.time_tags
    latest_timetags.each do |latest_timetag|
      timetag = find_timetag_record(id, latest_timetag)
      if timetag.nil?
        CreateRecordFromYT.create_timetag_record(id, latest_timetag)
      else
        update_timetag_record(timetag.id, latest_timetag)
      end
    end

    latest_author = latest_comment.author
    author = Author.find(comment_id: id)
    update_author_record(author.id, latest_author)
  end

  def self.update_timetag_record(id, latest_timetag)
    timetag_updator(id, latest_timetag)
  end

  def self.update_author_record(id, latest_author)
    author_updator(id, latest_author)
  end

  def self.find_comment_record(video_id, latest_comment)
    comment_info = CommentInfo.new(
      video_id: video_id,
      comment_id: latest_comment.comment_id
    )
    CommentRecord.find(comment_info)
  end

  def self.find_timetag_record(comment_id, latest_timetag)
    timetag_info = TimetagInfo.new(
      comment_id: comment_id,
      start_time: latest_timetag.start_time
    )
    TimetagRecord.find(timetag_info)
  end

  def self.video_updator(id, latest_video)
    video_info = VideoInfo.new(
      title:         latest_video.title,
      description:   latest_video.description,
      view_count:    latest_video.view_count,
      like_count:    latest_video.like_count,
      dislike_count: latest_video.dislike_count,
      duration:      latest_video.duration
    )
    VideoRecord.update(id, video_info)
  end

  def self.comment_updator(id, latest_comment)
    comment_info = CommentInfo.new(
      published_at: latest_comment.published_at,
      updated_at:   latest_comment.updated_at ?
                    latest_comment.updated_at : "",
      text_display: latest_comment.text_display,
      like_count:   latest_comment.like_count
    )
    CommentRecord.update(id, comment_info)
  end

  def self.timetag_updator(id, latest_timetag)
    timetag_info = TimetagInfo.new(
      yt_like_count: latest_timetag.like_count
    )
    TimetagRecord.update(id, timetag_info)
  end

  def self.author_updator(id, latest_author)
    author_info = AuthorInfo.new(
      author_name:        latest_author.author_name,
      author_image_url:   latest_author.author_image_url,
      author_channel_url: latest_author.author_channel_url,
      like_count:         latest_author.like_count
    )
    AuthorRecord.update(id, author_info)
  end
end
