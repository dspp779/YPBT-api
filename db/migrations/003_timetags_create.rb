# frozen_string_literal: true
require 'sequel'

# add new column:
#   db/migrations/003_timetags_create.rb
#   values/timetag_info.rb
#   lib/timetag_record.rb
#   lib/YBPTParser.rb
#   lib/refresh_database.rb
#   representers/timetag_info_reprA.rb
#   representers/timetag_info_reprB.rb
#   services/search_timetag.rb

Sequel.migration do
  change do
    create_table(:timetags) do
      primary_key :id
      foreign_key :comment_id
      Integer     :yt_like_count
      Integer     :our_like_count
      Integer     :our_dislike_count
      Integer     :start_time
      Integer     :end_time
      Integer     :duration
      String      :tag_type
      Float       :start_time_percentage
      Float       :end_time_percentage
    end
  end
end
