# frozen_string_literal: true

# Add click count for the tag
class TimetagAddOneClick
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :api_key_authenticate, lambda { |request|
    body_params = JSON.parse request.body.read
    api_key = body_params['api_key']

    if api_key == ENV['YOUTUBE_API_KEY']
      params = body_params
      Right(params)
    else
      Left(Error.new(:forbidden, "Authentication fail"))
    end
  }

  register :check_timetag, lambda { |params|
    timetag_id = params['time_tag_id'].to_i
    timetag = Timetag.find(id: timetag_id)

    if timetag
      Right(timetag)
    else
      Left(Error.new(:cannot_process,
        "Time tag (timetag_id: #{timetag_id}) cannot be found"))
    end
  }

  register :add_one_click, lambda { |timetag|
    timetag.click_count += 1
    timetag.save
    results = ApiInfo.new("Add one click on choosed time_tag")
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :api_key_authenticate
      step :check_timetag # is existed
      step :add_one_click
    end.call(params)
  end
end
