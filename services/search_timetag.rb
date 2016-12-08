# frozen_string_literal: true

# Search timetag info from database
class SearchTimetag
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :get_timetag_info, lambda { |params|
    timetag_id = params[:timetag_id]
    timetag = Timetag.find(id: timetag_id)
    if timetag
      Right(timetag: timetag)
    else
      Left(Error.new(:not_found,
                     "Timetag (timetag_id: #{timetag_id}) not found"))
    end
  }

  register :get_timetag_comment_info, lambda { |input|
    timetag_id = input[:timetag].id
    comment = GetTimetagCommentInfoQuery.call(timetag_id)
    if comment
      Right(timetag: input[:timetag], comment: comment)
    else
      Left(Error.new(:internal_error,
        "Fail to get comment info (timetag_id: #{timetag_id})"))
    end
  }

  register :get_timetag_author_info, lambda { |input|
    timetag_id = input[:timetag].id
    author = GetTimetagAuthorInfoQuery.call(timetag_id)
    if author
      Right(timetag: input[:timetag], comment: input[:comment], author: author)
    else
      Left(Error.new(:internal_error,
        "Fail to get author info (timetag_id: #{timetag_id})"))
    end
  }

  register :render_search_result, lambda { |input|
    results = TimetagInfo.new(
      id:                  input[:timetag].id,
      start_time:          input[:timetag].start_time,
      end_time:            input[:timetag].end_time,
      yt_like_count:       input[:timetag].yt_like_count,
      our_like_count:      input[:timetag].our_like_count,
      our_dislike_count:   input[:timetag].our_dislike_count,
      tag_type:            input[:timetag].tag_type,
      text_display:        input[:comment].text_display,
      author_name:         input[:author].author_name,
      author_image_url:    input[:author].author_image_url,
      author_channel_url:  input[:author].author_channel_url
    )
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :get_timetag_info
      step :get_timetag_comment_info
      step :get_timetag_author_info
      step :render_search_result
    end.call(params)
  end
end
