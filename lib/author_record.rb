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

  # Find author record
  def self.find(author_info)
    columns = [:id, :comment_id, :author_name, :author_image_url,
               :author_channel_url, :like_count]
    results = Author.where()
    columns.each do |col|
      val = author_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    unless results.first.nil?
      author_found = AuthorInfo.new(
        id:                 results.first.id,
        comment_id:         results.first.comment_id,
        author_name:        results.first.author_name,
        author_image_url:   results.first.author_image_url,
        author_channel_url: results.first.author_channel_url,
        like_count:         results.first.like_count
      )
    else
      nil
    end
  end

  # Update existed author record
  def self.update(id, author_info)
    author = Author.find(id: id)

    columns = [:comment_id, :author_name, :author_image_url,
               :author_channel_url, :like_count]
    columns.each do |col|
      val = author_info.send(col)
      author.send("#{col}=", author_info.send(col)) unless val.nil?
    end

    author.save
  end
end
