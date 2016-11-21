# frozen_string_literal: true

# Author record management
class AuthorRecord
  # Create new author record
  def self.create(author_info)
    Author.create(
      comment_id:         author_info.comment_id,
      author_name:        author_info.author_name,
      author_image_url:   author_info.author_image_url,
      author_channel_url: author_info.author_channel_url,
      like_count:         author_info.like_count
    )
  end

  # Update existed author record
  def self.update(id, author_info)
    author = Author.find(id: id)

    unless author_info.comment_id.nil?
      author.comment_id = author_info.comment_id
    end

    unless author_info.author_name.nil?
      author.author_name = author_info.author_name
    end

    unless author_info.author_image_url.nil?
      author.author_image_url = author_info.author_image_url
    end

    unless author_info.author_channel_url.nil?
      author.author_channel_url = author_info.author_channel_url
    end

    unless author_info.like_count.nil?
      author.like_count = author_info.like_count
    end

    author.save
  end
end
