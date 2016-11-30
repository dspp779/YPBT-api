# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :id
      String :video_id
      String :title
      String :description
      Integer :view_count
      Integer :like_count
      Integer :dislike_count
      Integer :duration
      column :last_update_time, DateTime
    end
  end
end
