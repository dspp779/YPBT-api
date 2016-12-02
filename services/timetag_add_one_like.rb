# frozen_string_literal: true

# Add like count for the tag
class TimetagAddOneLike
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_timetag, lambda { |request|
    body_params = JSON.parse request.body.read
    timetag_id = body_params['time_tag_id'].to_i
    timetag = Timetag.find(id: timetag_id)

    if timetag
      Right(timetag)
    else
      Left(Error.new(:cannot_process,
        "Time tag (timetag_id: #{timetag_id}) cannot be found"))
    end
  }

  register :add_one_like, lambda { |timetag|
    timetag.our_like_count += 1
    timetag.save
    results = ApiInfo.new("Add one like on choosed time_tag")
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :check_timetag # is existed
      step :add_one_like
    end.call(params)
  end
end
