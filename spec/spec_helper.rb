# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require_relative '../app'

include Rack::Test::Methods

def app
  YPBT_API
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
CASSETTE_FILE = 'youtube_api'
TEST_VIDEO_ID = 'FugHj7MGhss'
RESULT_FILE = "#{FIXTURES_FOLDER}/yt_api_results.yml"
YT_RESULT = YAML.load(File.read(RESULT_FILE))

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<API_KEY>') { ENV['YOUTUBE_API_KEY'] }
  #c.filter_sensitive_data('<API_KEY>') { app.config.YOUTUBE_API_KEY }
  c.filter_sensitive_data('<API_KEY_ESCAPED>') do
    URI.unescape(ENV['YOUTUBE_API_KEY'])
    #URI.unescape(app.config.YOUTUBE_API_KEY)
  end
end
