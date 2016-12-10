# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    alter_table(:timetags) do
      add_column :click_count, Integer, :default=>0, :null=>false
    end
  end
end
