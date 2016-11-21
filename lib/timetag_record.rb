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

  # Update existed timetag record
  def self.update(id, timetag_info)
    timetag = Timetag.find(id: id)

    unless timetag_info.comment_id.nil?
      timetag.comment_id = timetag_info.comment_id
    end

    unless timetag_info.yt_like_count.nil?
      timetag.yt_like_count = timetag_info.yt_like_count
    end

    unless timetag_info.our_like_count.nil?
      timetag.our_like_count = timetag_info.our_like_count
    end

    unless timetag_info.start_time.nil?
      timetag.start_time = timetag_info.start_time
    end

    timetag.save
  end
end
