# frozen_string_literal: true

#AuthorInfo = Struct.new :comment_id, :author_name, :author_image_url,
#                        :author_channel_url, :like_count
class AuthorInfo
  attr_accessor :comment_id, :author_name, :author_image_url,
                :author_channel_url, :like_count

  def initialize(comment_id: nil, author_name: nil, author_image_url: nil,
                 author_channel_url: nil, like_count: nil)
    @comment_id = comment_id
    @author_name = author_name
    @author_image_url = author_image_url
    @author_channel_url = author_channel_url
    @like_count = like_count
  end
end
