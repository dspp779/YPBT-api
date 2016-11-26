# frozen_string_literal: true

# Timetag record management
class TimetagRecord
  # Create new timetag record
  def self.create(timetag_info)
    existed_timetag = Timetag.find(comment_id: timetag_info.comment_id,
                                   start_time: timetag_info.start_time)
    return existed_timetag unless existed_timetag.nil?

    Timetag.create(
      comment_id:     timetag_info.comment_id,
      yt_like_count:  timetag_info.yt_like_count,
      our_like_count: timetag_info.our_like_count,
      start_time:     timetag_info.start_time,
    )
  end

  # Find timetag record
  def self.find(timetag_info)
    columns = [:id, :comment_id, :yt_like_count, :our_like_count, :start_time]
    results = Timetag.where()
    columns.each do |col|
      val = timetag_info.send(col)
      results = results.where(col => val) unless val.nil?
    end
    results.first
  end

  # Update existed timetag record
  def self.update(id, timetag_info)
    timetag = Timetag.find(id: id)

    columns = [:comment_id, :yt_like_count, :our_like_count, :start_time]
    columns.each do |col|
      val = timetag_info.send(col)
      timetag.send("#{col}=", timetag_info.send(col)) unless val.nil?
    end

    timetag.save
  end
end
