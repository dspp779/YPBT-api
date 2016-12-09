# frozen_string_literal: true
require 'sequel'

# add new column:
#   005_timetags_add_click_count.rb
#   values/timetag_info.rb
#   lib/timetag_record.rb
#   lib/construct_new_timetag.rb
#   lib/refresh_database.rb
#   lib/YBPTParser.rb
#   services/search_timetag.rb
#   timetag_add_one_click.rb
#   representers/timetag_info_reprA.rb
#   representers/timetag_info_reprB.rb
#   controllers/timetag.rb

Sequel.migration do
  change do
    alter_table(:timetags) do
      add_column :click_count, Integer
    end
  end
end
