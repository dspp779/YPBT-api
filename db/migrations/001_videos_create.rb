# frozen_string_literal: true
require 'sequel'

# add new column:
#   db/migration/001_videos_create.rb
#   values/video_info_rb
#   lib/video_record.rb
#   lib/YPBTParser.rb
#   lib/refresh_database.rb
#   representers/video_info_repr.rb

Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :id
      String   :video_id
      String   :title
      String   :description
      Integer  :view_count
      Integer  :like_count
      Integer  :dislike_count
      Integer  :duration
      String   :channel_id
      String   :channel_title
      String   :channel_description
      String   :channel_image_url
      DateTime :last_update_time
    end
  end
end
