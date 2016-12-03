# frozen_string_literal: true
require 'json'

# Represents any kind of error information for JSON API output
class ErrorRepresenter < Roar::Decorator
  property :code
  property :message

  ERROR = {
    OK: 200,
    cannot_process: 422,
    forbidden: 403,
    not_found: 404,
    bad_request: 400,
    internal_error: 500
  }.freeze

  def to_status_response
    [ERROR[@represented.code], { errors: [@represented.message] }.to_json]
  end
end
