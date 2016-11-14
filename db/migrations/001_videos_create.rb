# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:videos) do
      primary_key :id
      String :video_id
      String :title
    end
  end
end
