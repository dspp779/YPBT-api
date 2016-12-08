# frozen_string_literal: true

# Timetag record management
class TimetagRecord
  # Create new timetag record
  def self.create(timetag_info)
    existed_timetag = Timetag.find(comment_id: timetag_info.comment_id,
                                   start_time: timetag_info.start_time)
    return existed_timetag unless existed_timetag.nil?

    Timetag.create(
      comment_id:            timetag_info.comment_id,
      yt_like_count:         timetag_info.yt_like_count,
      our_like_count:        timetag_info.our_like_count,
      our_dislike_count:      timetag_info.our_dislike_count,
      tag_type:              timetag_info.tag_type,
      start_time:            timetag_info.start_time,
      end_time:              timetag_info.end_time,
      start_time_percentage: timetag_info.start_time_percentage,
      end_time_percentage:   timetag_info.end_time_percentage
    )
  end

  # Find timetag record
  def self.find(timetag_info)
    columns = [:id, :comment_id, :yt_like_count, :our_like_count,
               :our_dislike_count, :tag_type, :start_time, :end_time,
               :start_time_percentage, :end_time_percentage]
    results = Timetag.where()
    columns.each do |col|
      val = timetag_info.send(col)
      results = results.where(col => val) unless val.nil?
    end
    results.first
  end

  # Find all match timetag records
  def self.find_all(timetag_info)
    columns = [:id, :comment_id, :yt_like_count, :our_like_count,
               :our_dislike_count, :tag_type, :start_time, :end_time,
               :start_time_percentage, :end_time_percentage]
    results = Timetag.where()
    columns.each do |col|
      val = timetag_info.send(col)
      results = results.where(col => val) unless val.nil?
    end

    unless results.first.nil?
      timetags_found = results.map do |timetag_found|
        TimetagInfo.new(
          id:           timetag_found.id,
          comment_id:   timetag_found.comment_id,
          yt_like_count: timetag_found.yt_like_count,
          our_like_count: timetag_found.our_like_count,
          our_dislike_count: timetag_found.our_dislike_count,
          tag_type: timetag_found.tag_type,
          start_time: timetag_found.start_time,
          end_time: timetag_found.end_time,
          start_time_percentage: timetag_found.start_time_percentage,
          end_time_percentage: timetag_found.end_time_percentage
        )
      end
    else
      nil
    end
  end

  # Update existed timetag record
  def self.update(id, timetag_info)
    timetag = Timetag.find(id: id)

    columns = [:comment_id, :yt_like_count, :our_like_count, :our_dislike_count,
               :tag_type, :start_time, :end_time, :start_time_percentage,
               :end_time_percentage]
    columns.each do |col|
      val = timetag_info.send(col)
      timetag.send("#{col}=", timetag_info.send(col)) unless val.nil?
    end

    timetag.save
  end

  def self.add_one_like(id)
    timetag = Timetag.find(id: id)
    timetag.our_like_count += 1
    timetag.save
  end

  def self.add_one_dislike(id)
    timetag = Timetag.find(id: id)
    timetag.our_dislike_count += 1
    timetag.save
  end
end
