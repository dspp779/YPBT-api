# frozen_string_literal: true

# Represents an author's stored information
class Author < Sequel::Model
  many_to_one :comments
end
