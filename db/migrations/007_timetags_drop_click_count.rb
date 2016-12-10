# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    alter_table(:timetags) do
      drop_column :click_count
    end
  end
end
