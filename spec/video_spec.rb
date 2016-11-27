# frozen_string_literal: true
require_relative 'spec_helper'

COOLDOWN_TIME = 60.1 # second

describe 'Video Routes' do
  before do
    VCR.insert_cassette VIDEOS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end
=begin
  describe 'Find Video by its Video ID' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      DB[:timetags].delete
      DB[:authors].delete
      post 'api/v0.1/video', { url: HAPPY_VIDEO_URL }.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it '[HAPPY]: should find a video given a correct id' do
      get "api/v0.1/video/#{Video.first.video_id}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      video_data = JSON.parse(last_response.body)
      video_data['video_id'].length.must_be :>, 0
      video_data['title'].length.must_be :>, 0
    end

    it '[SAD]: should report if a video is not found' do
      get "api/v0.1/video/#{SAD_VIDEO_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_VIDEO_ID
    end
  end

  describe 'Loading and saving a new video by video_id' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      DB[:timetags].delete
      DB[:authors].delete
    end

    it '[HAPPY]: should load and save a new video by its video_id' do
      post 'api/v0.1/video',
           { url: HAPPY_VIDEO_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'video_id'
      body.must_include 'title'

      Video.count.must_equal 1
      Comment.count.must_be :>=, 1
      Timetag.count.must_be :>=, 1
      Author.count.must_be :>=, 1
    end

    it '[BAD]: should report error if given invalid video_id' do
      post 'api/v0.1/video',
           { url: SAD_VIDEO_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end

    it 'should report error if video already exists' do
      2.times do
        post 'api/v0.1/video',
             { url: HAPPY_VIDEO_URL }.to_json,
             'CONTENT_TYPE' => 'application/json'
      end

      last_response.status.must_equal 422
    end
  end
=end

  describe 'Request to update a video (including its followed comments)' do
=begin
    before do
      DB[:videos].delete
      DB[:comments].delete
      DB[:timetags].delete
      DB[:authors].delete
      post 'api/v0.1/video',
           { url: HAPPY_VIDEO_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end

    it '[HAPPY]: should update a existed video' do
      original = Video.first
      modified = Video.first
      modified.title = modified.description = modified.view_count = nil
      modified.like_count = modified.dislike_count = modified.duration = nil
      modified.last_update_time -= COOLDOWN_TIME
      modified.save
      put "#{API_VER}/video/#{original.video_id}"
      last_response.status.must_equal 200
      last_response.body == "Update to lastest"
      Video.count.must_equal 1
      updated = Video.first
      updated.title.must_equal original.title
      updated.description.must_equal original.description
      updated.last_update_time.wont_equal original.last_update_time
    end

    it '[HAPPY]: should create a new comment and downstream data' +
       ' if a comment is not existed in the database' do
      original = Comment.first
      modified = Comment.first
      modified.delete
      video = Video[original.video_id]
      video.last_update_time -= COOLDOWN_TIME
      video.save
      put "#{API_VER}/video/#{video.video_id}"
      last_response.status.must_equal 200
      last_response.body == "Update to lastest"
      updated = Comment.find(comment_id: original.comment_id)
      updated.video_id.must_equal original.video_id
      updated.text_display.must_equal original.text_display
    end

    it '[HAPPY]: should update a modified comment if that comment' +
       ' is already existed in the database' do
      original = Comment.first
      modified = Comment.first
      modified.text_display = nil
      video = Video[original.video_id]
      video.last_update_time -= COOLDOWN_TIME
      video.save
      put "#{API_VER}/video/#{video.video_id}"
      last_response.status.must_equal 200
      last_response.body == "Update to lastest"
      updated = Comment.find(comment_id: original.comment_id)
      updated.text_display.must_equal original.text_display
    end
=end
=begin
    it '[HAPPY]: should create a new timetag if the timetag is not' +
       'existed in the database' do

    end

    it '[HAPPY]: should update a modified timetag if that timetag is' +
       ' already existed in the database' do

    end

    it '[HAPPY]: should update a modified author if the comment of' +
       'this author is already existed in the database' do

    end
=end
=begin
    it '[HAPPY]: should have cd time between update queries' do
      video = Video.first
      video.last_update_time -= COOLDOWN_TIME
      video.save
      2.times { put "#{API_VER}/video/#{video.video_id}" }
      last_response.status.must_equal 200
      last_response.body == "Already update to lastest"
    end

    it '[BAD]: should report error if given invalid video_id' do
      put "api/v0.1/video/#{SAD_VIDEO_ID}"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end
=end
=begin
    it '[BAD]: should report error if stored video removed from YouTube' do
      original = Video.first
      original.update(video_id: REMOVED_VIDEO_ID).save

      put "api/v0.1/video/#{original.video_id}"

      last_response.status.must_equal 404
      last_response.body.must_include original.video_id
    end
=end
  end
end
