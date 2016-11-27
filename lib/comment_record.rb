# frozen_string_literal: true

# Comment record management
class CommentRecord
  # Create new comment record
  def self.create(comment_info)
    created_comment = Comment.create(
      video_id:      comment_info.video_id,
      comment_id:    comment_info.comment_id,
      published_at:  comment_info.published_at,
      updated_at:    comment_info.updated_at,
      text_display:  comment_info.text_display,
      like_count:    comment_info.like_count
    )
  end

  # Find comment record
  def self.find(comment_info)
    columns = [:id, :video_id, :comment_id, :published_at, :updated_at,
               :text_display, :like_count]
    results = Comment.where()
    columns.each do |col|
      val = comment_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    unless results.first.nil?
      comment_found = CommentInfo.new(
        id:           results.first.id,
        video_id:     results.first.video_id,
        comment_id:   results.first.comment_id,
        published_at: results.first.published_at,
        updated_at:   results.first.updated_at,
        text_display: results.first.text_display,
        like_count:   results.first.like_count
      )
    else
      nil
    end
  end

  # Find all match comment records
  def self.find_all(comment_info)
    columns = [:id, :video_id, :comment_id, :published_at, :updated_at,
               :text_display, :like_count]
    results = Comment.where()
    columns.each do |col|
      val = comment_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    unless results.first.nil?
      comments_found = results.map do |comment_found|
        CommentInfo.new(
          id:           comment_found.id,
          video_id:     comment_found.video_id,
          comment_id:   comment_found.comment_id,
          published_at: comment_found.published_at,
          updated_at:   comment_found.updated_at,
          text_display: comment_found.text_display,
          like_count:   comment_found.like_count
        )
      end
    else
      nil
    end
  end

  # Update existed comment record
  def self.update(id, comment_info)
    comment = Comment.find(id: id)

    columns = [:video_id, :comment_id, :published_at, :updated_at,
               :text_display, :like_count]
    columns.each do |col|
      val = comment_info.send(col)
      comment.send("#{col}=", comment_info.send(col)) unless val.nil?
    end

    comment.save
  end
end
