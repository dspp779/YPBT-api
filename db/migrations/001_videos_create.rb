# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :id
      String :video_id
      String :title
      String :description
      Interger :view_count
      Interger :like_count
      Interger :dislike_count
      String :duration
      TrueClass :comments_loading
    end
  end
end
