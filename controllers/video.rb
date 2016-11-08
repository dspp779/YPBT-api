# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'YPBT'

# GroupAPI web service
class YPBT_API < Sinatra::Base
  YT_VIDEO_REGEX = %r{\"fb:\/\/group\/(\d+)\"}

  get "/#{API_VER}/video/:video_id/?" do
    video_id = params[:video_id]
    begin
      video = YoutubeVideo::Video.find(video_id: video_id)

      content_type 'application/json'
      { video_id: video_id, title: video.title }.to_json
    rescue
      content_type 'text/plain'
      halt 404, "Video (video_id: #{video_id}) not found"
    end
  end

  # Body args (JSON) e.g.: {"url": "http://facebook.com/groups/group_name"}
  post "/#{API_VER}/video/?" do
    begin
      body_params = JSON.parse request.body.read
      yt_video_url = body_params['url']
      yt_video_html = HTTP.get(yt_video_url).body.to_s
      yt_video_id = yt_video_html.match(YT_VIDEO_REGEX)[1]

      if Video.find(video_id: yt_video_id)
        halt 422, "Video (id: #{yt_video_id})already exists"
      end

      yt_video = YoutubeVideo::Video.find(video_id: yt_video_id)
    rescue
      content_type 'text/plain'
      halt 400, "Video (url: #{yt_video_url}) could not be found"
    end

    begin
      video = Video.create(video_id: yt_video.id, title: yt_video.title)

      yt_video.commentthreads.each do |yt_comment|
        Posting.create(
          video_id:           video.id,
          comment_id:         yt_comment.comment_id,
          updated_at:         yt_comment.updated_at,
          published_at:       yt_comment.published_at,
          text_display:       yt_comment.text_display,
          author_name:        yt_comment.author&.author_name,
          author_image_url:   yt_comment.author&.author_image_url,
          author_channel_url: yt_comment.author&.author_channel_url,
          like_count:         yt_comment.author&.like_count
        )
      end

      content_type 'application/json'
      { video_id: video.id, title: video.title }.to_json
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create video (id: #{yt_video_id})"
    end
  end
end
