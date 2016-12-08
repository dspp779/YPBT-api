# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Comments Route' do
  before do
    VCR.insert_cassette COMMENTS_CASSETTE, record: :new_episodes
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

    it '[HAPPY]: update the records for the target video and return ' +
       'information of all storaged comments for the target video' do
      video = Video.first
      original_update_time = video.last_update_time
      video.last_update_time -= COOLDOWN_TIME
      video.save
      get "#{API_VER}/Comments/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      modified_update_time = video.last_update_time
      modified_update_time.wont_equal original_update_time

      comments_data = JSON.parse(last_response.body)
      comments_data.length.must_be :>=, 1
      first_comment = comments_data.first
      first_comment["video_id"].must_equal HAPPY_VIDEO_ID
      first_comment["comment_id"].length.must_be :>, 0
      first_comment["text_display"].length.must_be :>, 0
      first_comment["like_count"].wont_be_nil
      first_comment["author_name"].length.must_be :>, 0
      first_comment["author_image_url"].length.must_be :>, 0
      first_comment["author_channel_url"].length.must_be :>, 0
    end

    it '[HAPPY]: not update the records for the target video if still in ' +
       'its cd time, and then return information of all storaged comments ' +
       'for the target video' do
      video = Video.first
      video.last_update_time -= 1
      video.save
      original_update_time = video.last_update_time
      get "#{API_VER}/Comments/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      modified_update_time = video.last_update_time
      modified_update_time.must_equal original_update_time

      comments_data = JSON.parse(last_response.body)
      comments_data.length.must_be :>=, 1
      first_comment = comments_data.first
      first_comment["video_id"].must_equal HAPPY_VIDEO_ID
      first_comment["comment_id"].length.must_be :>, 0
      first_comment["text_display"].length.must_be :>, 0
      first_comment["like_count"].wont_be_nil
      first_comment["author_name"].length.must_be :>, 0
      first_comment["author_image_url"].length.must_be :>, 0
      first_comment["author_channel_url"].length.must_be :>, 0
    end

    it '[HAPPY]: return information of targeted comment from database' do
      get "#{API_VER}/Comment/#{HAPPY_COMMENT_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      comment_data = JSON.parse(last_response.body)
      comment_data["video_id"].must_equal HAPPY_VIDEO_ID
      comment_data["comment_id"].length.must_be :>, 0
      comment_data["text_display"].length.must_be :>, 0
      comment_data["like_count"].wont_be_nil
      comment_data["author_name"].length.must_be :>, 0
      comment_data["author_image_url"].length.must_be :>, 0
      comment_data["author_channel_url"].length.must_be :>, 0
    end

    it '[SAD]: return not found if targeted comment is not existed in db' do
      get "#{API_VER}/Comment/#{SAD_COMMENT_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_COMMENT_ID
    end
  end

  describe 'when no storaged videos existed' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      DB[:timetags].delete
      DB[:authors].delete
    end

    it '[HAPPY]: create the records for the target video if it can be found ' +
       'on YouTube, and then return information of all storaged comments ' +
       'for the target video' do
      get "#{API_VER}/Comments/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'

      comments_data = JSON.parse(last_response.body)
      comments_data.length.must_be :>=, 1
      first_comment = comments_data.first
      first_comment["video_id"].must_equal HAPPY_VIDEO_ID
      first_comment["comment_id"].length.must_be :>, 0
      first_comment["text_display"].length.must_be :>, 0
      first_comment["like_count"].wont_be_nil
      first_comment["author_name"].length.must_be :>, 0
      first_comment["author_image_url"].length.must_be :>, 0
      first_comment["author_channel_url"].length.must_be :>, 0
    end

    it '[SAD]: report not found if target video not available on YouTube' do
      get "#{API_VER}/Comments/#{SAD_VIDEO_ID}"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end
  end
end
