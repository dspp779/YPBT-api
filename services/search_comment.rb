# frozen_string_literal: true

# Search comment info from database
class SearchComment
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :get_comment_info, lambda { |params|
    comment_id = params[:comment_id]
    comment = Comment.find(comment_id: comment_id)
    if comment
      Right(comment: comment)
    else
      Left(Error.new(:not_found,
                     "Comment (comment_id: #{comment_id}) not found"))
    end
  }

  register :get_comment_video_info, lambda { |input|
    comment_id = input[:comment].comment_id
    video = GetCommentVideoInfoQuery.call(comment_id)
    if video
      Right(comment: input[:comment], video: video)
    else
      Left(Error.new(:internal_error,
        "Fail to get video info (comment_id: #{comment_id})"))
    end
  }

  register :get_comment_author_info, lambda { |input|
    comment_id = input[:comment].comment_id
    author = GetCommentAuthorInfoQuery.call(comment_id)
    if author
      Right(comment: input[:comment], video: input[:video], author: author)
    else
      Left(Error.new(:internal_error,
        "Fail to get author info (comment_id: #{comment_id})"))
    end
  }

  register :render_search_result, lambda { |input|
    results = CommentInfo.new(
      video_id:            input[:video].video_id,
      comment_id:          input[:comment].comment_id,
      text_display:        input[:comment].text_display,
      like_count:          input[:comment].like_count,
      author_name:         input[:author].author_name,
      author_image_url:    input[:author].author_image_url,
      author_channel_url:  input[:author].author_channel_url
    )
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :get_comment_info
      step :get_comment_video_info
      step :get_comment_author_info
      step :render_search_result
    end.call(params)
  end
end
