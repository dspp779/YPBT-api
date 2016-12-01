# frozen_string_literal: true

# Represents collected timetag's information as thread for JSON API output
class TimetagInfoThreadRepresenter
  def initialize(timetags)
    @timetags = timetags.map do |timetag_info|
      JSON.parse(TimetagInfoRepresenterB.new(timetag_info).to_json)
    end
  end

  def to_json
    @timetags.to_json
  end
end
