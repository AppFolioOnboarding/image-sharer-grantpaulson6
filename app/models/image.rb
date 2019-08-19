require 'uri'

class Image < ApplicationRecord
  validates :name, :url, presence: true
  validate :valid_url?

  # should this be in a validator class?
  def valid_url?
    # is this a proper way of handling errors? of using control flow?
    if URI.parse(url).host.nil?
      errors.messages[:url] ||= []
      errors.messages[:url].push('must be valid')
    end
  rescue URI::InvalidURIError
    errors.messages[:url] ||= []
    errors.messages[:url].push('must be valid')
  end
end
