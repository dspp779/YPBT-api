# frozen_string_literal: true

class YPBTParserVideoOnly
  def self.call(video)
    arrayOfRecord = parse_video(video)
  end

  def self.parse_video(video)
    arrayOfRecord = 1.times.map { CompleteRecord.new() }
    arrayOfRecord = arrayOfRecord.map do |record|
      YPBTParser.fill_in_video_info(record, video)
      record
    end
  end
end
