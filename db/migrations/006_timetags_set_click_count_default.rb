# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    alter_table(:timetags) do
      set_column_default :click_count, 0
    end
  end
end
