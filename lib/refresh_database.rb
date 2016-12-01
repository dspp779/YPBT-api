# frozen_string_literal: true

class RefreshDatabase
  def self.call(arrayOfRecord)
    arrayOfRecord = refresh_video(arrayOfRecord)
    arrayOfRecord = refresh_comment(arrayOfRecord)
    arrayOfRecord = refresh_timetag(arrayOfRecord)
    arrayOfRecord = refresh_author(arrayOfRecord)
  end

  def self.refresh_video(arrayOfRecord)
    arrayOfRecord = arrayOfRecord.map do |record|
      id = find_video_record(record)
      if id.nil?
        video_info = create_video_record(record)
      else
        video_info = update_video_record(id, record)
      end
	  record.video_info.id = video_info.id
      record.comment_info.video_id = video_info.id
      record
    end
  end

  def self.refresh_comment(arrayOfRecord)
    arrayOfRecord = arrayOfRecord.map do |record|
      id = find_comment_record(record)
      if id.nil?
        comment_info = create_comment_record(record)
      else
        comment_info = update_comment_record(id, record)
      end
      record.comment_info.id = comment_info.id
      record.comment_info.comment_id = comment_comfirm_identity(record)
      record.timetag_info.comment_id = comment_info.id
      record.author_info.comment_id = comment_info.id
      record
    end
  end

  def self.refresh_timetag(arrayOfRecord)
    arrayOfRecord = arrayOfRecord.map do |record|
      id = find_timetag_record(record)
      if id.nil?
        timetag_info = create_timetag_record(record)
      else
        timetag_info = update_timetag_record(id, record)
      end
      record.timetag_info.id = timetag_info.id
      record
    end
  end

  def self.refresh_author(arrayOfRecord)
    arrayOfRecord = arrayOfRecord.map do |record|
      id = find_author_record(record)
      if id.nil?
        author_info = create_author_record(record)
      else
        author_info = update_author_record(id, record)
      end
      record.author_info.id = author_info.id
      record
    end
  end

  def self.find_video_record(record)
    video_info = VideoInfo.new(
      id:       record.video_info.id,
      video_id: record.video_info.video_id
    )
    video = VideoRecord.find(video_info)
    unless video.nil?; video.id; else nil; end
  end

  def self.find_comment_record(record)
    comment_info = CommentInfo.new(
      id:       record.comment_info.id,
      video_id: record.comment_info.video_id,
      comment_id: record.comment_info.comment_id
    )
    comment = CommentRecord.find(comment_info)
    unless comment.nil?; comment.id; else nil; end
  end

  def self.find_timetag_record(record)
    timetag_info = TimetagInfo.new(
      id:         record.timetag_info.id,
      comment_id: record.timetag_info.comment_id,
      start_time: record.timetag_info.start_time
    )
    timetag = TimetagRecord.find(timetag_info)
    unless timetag.nil?; timetag.id; else nil; end
  end

  def self.find_author_record(record)
    author_info = AuthorInfo.new(
      id:         record.author_info.id,
      comment_id: record.author_info.comment_id,
    )
    author = AuthorRecord.find(author_info)
    unless author.nil?; author.id; else nil; end
  end

  def self.create_video_record(record)
    video_info = VideoInfo.new(
      video_id:            record.video_info.video_id,
      title:               record.video_info.title,
      description:         record.video_info.description,
      view_count:          record.video_info.view_count,
      like_count:          record.video_info.like_count,
      dislike_count:       record.video_info.dislike_count,
      duration:            record.video_info.duration,
      channel_title:       record.video_info.channel_title,
      channel_description: record.video_info.channel_description,
      channel_image_url:   record.video_info.channel_image_url
    )
    created_video = VideoRecord.create(video_info)
    VideoInfo.new(id: created_video.id)
  end

  def self.create_comment_record(record)
    comment_info = CommentInfo.new(
      video_id:     record.video_info.id,
      comment_id:   record.comment_info.comment_id,
      published_at: record.comment_info.published_at,
      updated_at:   record.comment_info.updated_at,
      text_display: record.comment_info.text_display,
      like_count:   record.comment_info.like_count
    )
    created_comment = CommentRecord.create(comment_info)
    CommentInfo.new(id: created_comment.id)
  end

  def self.create_timetag_record(record)
    timetag_info = TimetagInfo.new(
      comment_id:            record.comment_info.id,
      yt_like_count:         record.timetag_info.yt_like_count,
      our_like_count:        record.timetag_info.our_like_count,
      our_unlike_count:      record.timetag_info.our_unlike_count,
      tag_type:              record.timetag_info.tag_type,
      start_time:            record.timetag_info.start_time,
      start_time_percentage: record.timetag_info.start_time_percentage
    )
    created_timetag = TimetagRecord.create(timetag_info)
    TimetagInfo.new(id: created_timetag.id)
  end

  def self.create_author_record(record)
    author_info = AuthorInfo.new(
      comment_id:         record.comment_info.id,
      author_name:        record.author_info.author_name,
      author_image_url:   record.author_info.author_image_url,
      author_channel_url: record.author_info.author_channel_url,
      like_count:         record.author_info.like_count
    )
    created_author = AuthorRecord.create(author_info)
    AuthorInfo.new(id: created_author.id)
  end

  def self.update_video_record(id, record)
    video_info = VideoInfo.new(
      title:               record.video_info.title,
      description:         record.video_info.description,
      view_count:          record.video_info.view_count,
      like_count:          record.video_info.like_count,
      dislike_count:       record.video_info.dislike_count,
      duration:            record.video_info.duration,
      channel_title:       record.video_info.channel_title,
      channel_description: record.video_info.channel_description,
      channel_image_url:   record.video_info.channel_image_url
    )
    updated_video = VideoRecord.update(id, video_info)
    VideoInfo.new(id: updated_video.id)
  end

  def self.update_comment_record(id, record)
    comment_info = CommentInfo.new(
      published_at: record.comment_info.published_at,
      updated_at:   record.comment_info.updated_at,
      text_display: record.comment_info.text_display,
      like_count:   record.comment_info.like_count
    )
    updated_comment = CommentRecord.update(id, comment_info)
    CommentInfo.new(id: updated_comment.id)
  end

  def self.update_timetag_record(id, record)
    timetag_info = TimetagInfo.new(
      yt_like_count: record.timetag_info.yt_like_count
    )
    updated_timetag = TimetagRecord.update(id, timetag_info)
    TimetagInfo.new(id: updated_timetag.id)
  end

  def self.update_author_record(id, record)
    author_info = AuthorInfo.new(
      author_name:        record.author_info.author_name,
      author_image_url:   record.author_info.author_image_url,
      author_channel_url: record.author_info.author_channel_url,
      like_count:         record.author_info.like_count
    )
    updated_author = AuthorRecord.update(id, author_info)
    AuthorInfo.new(id: updated_author.id)
  end

  def self.comment_comfirm_identity(record)
    # needed when create a new timetag record without its corrisponding
    # comment identity (i.e.: comment_id == "")
    unless record.comment_info.comment_id == ""
      record.comment_info.comment_id
    else
      id = record.comment_info.id
      comment_info = CommentInfo.new(comment_id: id)
      CommentRecord.update(id, comment_info)
      id.to_s
    end
  end
end
