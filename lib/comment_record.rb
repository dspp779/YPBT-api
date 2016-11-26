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
    results.first
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
