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

  # Update existed comment record
  def self.update(id, comment_info)
    comment = Comment.find(id: id)

    unless comment_info.video_id.nil?
      comment.video_id = comment_info.video_id
    end

    unless comment_info.comment_id.nil?
      comment.title = comment_info.comment_id
    end

    unless comment_info.published_at.nil?
      comment.published_at = comment_info.published_at
    end

    unless comment_info.updated_at.nil?
      comment.updated_at = comment_info.updated_at
    end

    unless comment_info.text_display.nil?
      comment.text_display = comment_info.text_display
    end

    unless comment_info.like_count.nil?
      comment.like_count = comment_info.like_count
    end

    comment.save
  end
end
