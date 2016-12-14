# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Videos Route' do
  before do
    VCR.insert_cassette VIDEOS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'when some storaged videos existed' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      DB[:timetags].delete
      DB[:authors].delete
      get "#{API_VER}/Comments/#{HAPPY_VIDEO_ID}"
    end

    it '[HAPPY]: return information of all storaged videos' do
      get "#{API_VER}/Videos"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      videos_data = JSON.parse(last_response.body)
      videos_data.length.must_equal 1
      first_video = videos_data.first
      first_video["video_id"].must_equal HAPPY_VIDEO_ID
      first_video["title"].length.must_be :>, 0
      first_video["description"].length.must_be :>, 0
      first_video["view_count"].wont_be_nil
      first_video["like_count"].wont_be_nil
      first_video["duration"].wont_be_nil
      first_video["channel_id"].length.must_be :>, 0
      first_video["channel_title"].length.must_be :>, 0
      first_video["channel_image_url"].length.must_be :>, 0
      first_video["channel_description"].length.must_be :>, 0
    end

    it '[HAPPY]: return information of target video from database' do
      get "#{API_VER}/Video/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      video_data = JSON.parse(last_response.body)
      video_data['video_id'].must_equal HAPPY_VIDEO_ID
      video_data['title'].length.must_be :>, 0
      video_data["description"].length.must_be :>, 0
      video_data["view_count"].wont_be_nil
      video_data["like_count"].wont_be_nil
      video_data["dislike_count"].wont_be_nil
      video_data["duration"].wont_be_nil
      video_data["channel_id"].length.must_be :>, 0
      video_data["channel_title"].length.must_be :>, 0
      video_data["channel_image_url"].length.must_be :>, 0
      video_data["channel_description"].length.must_be :>, 0
    end
  end

  describe 'when no storaged videos existed' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      DB[:timetags].delete
      DB[:authors].delete
    end

    it '[SAD]: should report that no storaged video existed' do
      get "#{API_VER}/Videos"

      last_response.status.must_equal 404
    end

    it '[HAPPY]: return information of targeted video directly from ' +
       'YouTube API if the video can be found on YouTube' do
      get "#{API_VER}/Video/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      video_data = JSON.parse(last_response.body)
      video_data['video_id'].must_equal HAPPY_VIDEO_ID
      video_data['title'].length.must_be :>, 0
      video_data["description"].length.must_be :>, 0
      video_data["view_count"].wont_be_nil
      video_data["like_count"].wont_be_nil
      video_data["dislike_count"].wont_be_nil
      video_data["duration"].wont_be_nil
      video_data["channel_id"].length.must_be :>, 0
      video_data["channel_title"].length.must_be :>, 0
      video_data["channel_image_url"].length.must_be :>, 0
      video_data["channel_description"].length.must_be :>, 0
    end

    it '[SAD]: should report if a target video is not found in YouTube' do
      get "#{API_VER}/Video/#{SAD_VIDEO_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_VIDEO_ID
    end
  end
end
