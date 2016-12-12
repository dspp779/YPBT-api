# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Timetags Route' do
  before do
    VCR.insert_cassette TIMETAGS_CASSETTE, record: :new_episodes
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
       'information of all storaged timetags for the target video' do
      video = Video.first
      original_update_time = video.last_update_time
      video.last_update_time -= COOLDOWN_TIME
      video.save
      get "#{API_VER}/TimeTags/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      modified_update_time = video.last_update_time
      modified_update_time.wont_equal original_update_time

      timetags_data = JSON.parse(last_response.body)
      timetags_data.length.must_be :>=, 1
      first_timetag = timetags_data.first
      first_timetag["time_tag_id"].wont_be_nil
      first_timetag["start_time"].length.must_be :>, 0
      first_timetag["start_time_percentage"].wont_be_nil
      first_timetag["click_count"].wont_be_nil
      first_timetag["like_count"].wont_be_nil
    end

    it '[HAPPY]: not update the records for the target video if still in ' +
       'its cd time, and then return information of all storaged timetags ' +
       'for the target video' do
      video = Video.first
      video.last_update_time -= 1
      video.save
      original_update_time = video.last_update_time
      get "#{API_VER}/TimeTags/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      modified_update_time = video.last_update_time
      modified_update_time.must_equal original_update_time

      timetags_data = JSON.parse(last_response.body)
      timetags_data.length.must_be :>=, 1
      first_timetag = timetags_data.first
      first_timetag["time_tag_id"].wont_be_nil
      first_timetag["start_time"].length.must_be :>, 0
      first_timetag["start_time_percentage"].wont_be_nil
      first_timetag["click_count"].wont_be_nil
      first_timetag["like_count"].wont_be_nil
    end

    it '[HAPPY]: return information of targeted timetag from database' do
      get "#{API_VER}/TimeTag/#{Timetag.first.id}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      timetag_data = JSON.parse(last_response.body)
      timetag_data["time_tag_id"].wont_be_nil
      timetag_data["start_time"].length.must_be :>, 0
      timetag_data["click_count"].wont_be_nil
      timetag_data["like_count"].wont_be_nil
      timetag_data["dislike_count"].wont_be_nil
      timetag_data["comment_text_display"].length.must_be :>, 0
      timetag_data["comment_author_name"].length.must_be :>, 0
      timetag_data["comment_author_image_url"].length.must_be :>, 0
      timetag_data["comment_author_channel_url"].length.must_be :>, 0
    end

    it '[SAD]: return not found if targeted timetag is not existed in db' do
      get "#{API_VER}/Comment/#{SAD_TIMETAG_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_TIMETAG_ID
    end

    it '[HAPPY]: allowed adding new TimeTag' do
      original_timetag_number = Timetag.all.length

      post 'api/v0.1/TimeTag', { video_id: HAPPY_VIDEO_ID,
        start_time: "PT15M26S", tag_type: "timetag",
        comment_text_display: "post_test",
        api_key: ENV['YOUTUBE_API_KEY']}.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      modified_timetag_number = Timetag.all.length
      modified_timetag_number.must_equal (original_timetag_number + 1)

      added_timetag = Timetag.last
      parent_comment = Comment.find(id: added_timetag.comment_id)
      parent_video = Video.find(id: parent_comment.video_id)
      parent_video.video_id.must_equal HAPPY_VIDEO_ID

      added_timetag.start_time.wont_be_nil
      added_timetag.end_time.must_be_nil
      added_timetag.tag_type.must_equal "timetag"
      parent_comment.text_display.must_equal "post_test"

      returned_timetag = JSON.parse(last_response.body)
      returned_timetag["time_tag_id"].wont_be_nil
      returned_timetag["start_time"].length.must_be :>, 0
      returned_timetag["start_time_percentage"].wont_be_nil
      returned_timetag["click_count"].wont_be_nil
      returned_timetag["like_count"].wont_be_nil
    end

    it '[SAD]: should report if authentication not pass' do
      post 'api/v0.1/TimeTag', { video_id: HAPPY_VIDEO_ID,
        start_time: "PT15M26S", tag_type: "timetag",
        comment_text_display: "post_test",
        api_key: FAKE_API_KEY}.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 403
      last_response.body.must_include "Authentication fail"
    end

    it '[HAPPY]: allowed adding one click count for a tag' do
      timetag_id = Timetag.first.id
      original_click_count = Timetag.first.click_count

      put 'api/v0.1/TimeTag/add_one_click', { time_tag_id: timetag_id,
        api_key: ENV['YOUTUBE_API_KEY'] }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      modified_click_count = Timetag.first.click_count
      modified_click_count.must_equal (original_click_count + 1)
    end

    it '[SAD]: should report if authentication not pass' do
      timetag_id = Timetag.first.id

      put 'api/v0.1/TimeTag/add_one_click', { time_tag_id: timetag_id,
        api_key: FAKE_API_KEY }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 403
      last_response.body.must_include "Authentication fail"
    end

    it '[SAD]: should report if target timetag is not existed' do
      timetag_id = "0"
      put 'api/v0.1/TimeTag/add_one_click', { time_tag_id: timetag_id,
        api_key: ENV['YOUTUBE_API_KEY'] }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
      last_response.body.must_include timetag_id
    end

    it '[HAPPY]: allowed adding one like count for a tag' do
      timetag_id = Timetag.first.id
      original_like_count = Timetag.first.our_like_count

      put 'api/v0.1/TimeTag/add_one_like', { time_tag_id: timetag_id,
        api_key: ENV['YOUTUBE_API_KEY'] }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      modified_like_count = Timetag.first.our_like_count
      modified_like_count.must_equal (original_like_count + 1)
    end

    it '[SAD]: should report if authentication not pass' do
      timetag_id = Timetag.first.id

      put 'api/v0.1/TimeTag/add_one_like', { time_tag_id: timetag_id,
        api_key: FAKE_API_KEY }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 403
      last_response.body.must_include "Authentication fail"
    end

    it '[SAD]: should report if target timetag is not existed' do
      timetag_id = "0"
      put 'api/v0.1/TimeTag/add_one_like', { time_tag_id: timetag_id,
        api_key: ENV['YOUTUBE_API_KEY'] }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
      last_response.body.must_include timetag_id
    end

    it '[HAPPY]: allowed adding one dislike count for a tag' do
      timetag_id = Timetag.first.id
      original_dislike_count = Timetag.first.our_dislike_count

      put 'api/v0.1/TimeTag/add_one_dislike', { time_tag_id: timetag_id,
        api_key: ENV['YOUTUBE_API_KEY'] }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      modified_dislike_count = Timetag.first.our_dislike_count
      modified_dislike_count.must_equal (original_dislike_count + 1)
    end

    it '[SAD]: should report if authentication not pass' do
      timetag_id = Timetag.first.id

      put 'api/v0.1/TimeTag/add_one_dislike', { time_tag_id: timetag_id,
        api_key: FAKE_API_KEY }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 403
      last_response.body.must_include "Authentication fail"
    end

    it '[SAD]: should report if target timetag is not existed' do
      timetag_id = "0"
      put 'api/v0.1/TimeTag/add_one_dislike', { time_tag_id: timetag_id,
        api_key: ENV['YOUTUBE_API_KEY'] }.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
      last_response.body.must_include timetag_id
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
       'on YouTube, and then return information of all storaged timetags ' +
       'for the target video' do
      get "#{API_VER}/TimeTags/#{HAPPY_VIDEO_ID}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'

      timetags_data = JSON.parse(last_response.body)
      timetags_data.length.must_be :>=, 1
      first_timetag = timetags_data.first
      first_timetag["time_tag_id"].wont_be_nil
      first_timetag["start_time"].length.must_be :>, 0
      first_timetag["start_time_percentage"].wont_be_nil
      first_timetag["click_count"].wont_be_nil
      first_timetag["like_count"].wont_be_nil
    end

    it '[SAD]: report not found if target video not available on YouTube' do
      get "#{API_VER}/TimeTags/#{SAD_VIDEO_ID}"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end

    it '[HAPPY]: allowed adding new TimeTag even no record already existed ' +
       'in the database for an available video' do
      original_timetag_number = Timetag.all.length

      post 'api/v0.1/TimeTag', { video_id: HAPPY_VIDEO_ID,
        start_time: "PT15M26S", tag_type: "timetag",
        comment_text_display: "post_test",
        api_key: ENV['YOUTUBE_API_KEY']}.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      modified_timetag_number = Timetag.all.length
      modified_timetag_number.must_equal (original_timetag_number + 1)

      added_timetag = Timetag.last
      parent_comment = Comment.find(id: added_timetag.comment_id)
      parent_video = Video.find(id: parent_comment.video_id)
      parent_video.video_id.must_equal HAPPY_VIDEO_ID

      added_timetag.start_time.wont_be_nil
      added_timetag.end_time.must_be_nil
      added_timetag.tag_type.must_equal "timetag"
      parent_comment.text_display.must_equal "post_test"

      returned_timetag = JSON.parse(last_response.body)
      returned_timetag["time_tag_id"].wont_be_nil
      returned_timetag["start_time"].length.must_be :>, 0
      returned_timetag["start_time_percentage"].wont_be_nil
      returned_timetag["click_count"].wont_be_nil
      returned_timetag["like_count"].wont_be_nil
    end

    it '[SAD]: should report if the video on which the new timetag adding ' +
       'is not avaiable on YouTube' do
      post 'api/v0.1/TimeTag', { video_id: SAD_VIDEO_ID,
        start_time: "PT15M26S", tag_type: "timetag",
        comment_text_display: "post_test",
        api_key: ENV['YOUTUBE_API_KEY']}.to_json,
        'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end
  end
end
