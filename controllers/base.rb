# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'YPBT'

# GroupAPI web service
class YPBT_API < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  ENV['YOUTUBE_API_KEY'] = config.YOUTUBE_API_KEY

  API_VER = 'api/v0.1'

  get '/?' do
    "YPBT_API latest version endpoints are at: /#{API_VER}/"
  end
end
