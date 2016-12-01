# frozen_string_literal: true

# Represents api plain text information for JSON API output
class ApiInfoRepresenter < Roar::Decorator
  include Roar::JSON

  property :message
end
