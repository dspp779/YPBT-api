# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Video Routes' do
  before do
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find Video by its Video ID' do
    before do
      DB[:videos].delete
      DB[:comments].delete
      post 'api/v0.1/video', { "video_id": HAPPY_VIDEO_ID }.to_json, 'CONTENT_TYPE' => 'application/json'
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

  describe 'Get the first three comments from a video' do
    it '[HAPPY]: should find the first three comments' do
      get "api/v0.1/video/#{Video.first.video_id}/commentthreads"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      comments_data = JSON.parse(last_response.body)
      comments_data.size.must_equal 3
      first_comment = comments_data.first
      first_comment['author_name'].length.must_be :>=, 0
      first_comment['comment_text'].length.must_be :>=, 0
      first_comment['like_count'].to_s.length.must_be :>=, 0
      first_comment['author_channel_url'].length.must_be :>=, 0
    end

    it '[SAD]: should report if the commentthreads cannot be found' do
      get "api/v0.1/video/#{SAD_VIDEO_ID}/commentthreads"

      last_response.status.must_equal 400
      last_response.body.must_include SAD_VIDEO_ID
    end
  end
end
