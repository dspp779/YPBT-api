# frozen_string_literal: true

# Represents overall video information for JSON API output
class VideoInfoRepresenter
  attr_reader :video_info, :video_id, :title, :description, :view_count,
              :like_count, :dislike_count, :duration, :channel_id,
              :channel_title, :channel_description, :channel_image_url

  def initialize(video_info)
    @video_info                 = video_info
    @video_id                   = set_video_id(@video_info)
    @title                      = set_title(@video_info)
    @description                = set_description(@video_info)
    @view_count                 = set_view_count(@video_info)
    @like_count                 = set_like_count(@video_info)
    @dislike_count              = set_dislike_count(@video_info)
    @duration                   = set_duration(@video_info)
    @channel_id                 = set_channel_id(@video_info)
    @channel_title              = set_channel_title(@video_info)
    @channel_description        = set_channel_description(@video_info)
    @channel_image_url          = set_channel_image_url(@video_info)
  end

  def to_json
    { video_id:            @video_id,
      title:               @title,
      description:         @description,
      view_count:          @view_count,
      like_count:          @like_count,
      dislike_count:       @dislike_count,
      duration:            @duration,
      channel_id:          @channel_id,
      channel_title:       @channel_title,
      channel_description: @channel_description,
      channel_image_url:   @channel_image_url
    }.to_json
  end

  def set_video_id(video_info)
    video_info.video_id
  end

  def set_title(video_info)
    video_info.title
  end

  def set_description(video_info)
    video_info.description
  end

  def set_view_count(video_info)
    video_info.view_count
  end

  def set_like_count(video_info)
    video_info.like_count
  end

  def set_dislike_count(video_info)
    video_info.dislike_count
  end

  def set_duration(video_info)
    video_info.duration
    #duration_in_second = video_info.duration
    #Duration.new(duration_in_second).iso8601
  end

  def set_channel_id(video_info)
    video_info.channel_id
  end

  def set_channel_title(video_info)
    video_info.channel_title
  end

  def set_channel_description(video_info)
    video_info.channel_description
  end

  def set_channel_image_url(video_info)
    video_info.channel_image_url
  end
end

=begin
class VideoInfoRepresenter < Roar::Decorator
  include Roar::JSON

  property :video_id
  property :title
  property :description
  property :view_count
  property :like_count
  property :dislike_count
  property :duration
  property :channel_id, render_nil: true
  property :channel_title, render_nil: true
  property :channel_description, render_nil: true
  property :channel_image_url, render_nil: true
end
=end
