# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:timetags) do
      primary_key :id
      foreign_key :comment_id
      Integer :yt_like_count
      Integer :our_like_count
      Integer :our_unlike_count
      Integer :start_time
      Integer :end_time
      Integer :duration
      String  :tag_type
      Float   :start_time_percentage
      Float   :end_time_percentage
    end
  end
end
