require 'uri'

class Image < ApplicationRecord
  validates :name, :url, presence: true
  validate :valid_url?

  # should this be in a validator class?
  def valid_url?
    # is this a proper way of handling errors? of using control flow?
    URI.parse(url).host.nil? && errors.messages['url'] = ['must be valid.']
  rescue URI::InvalidURIError
    errors.messages['url'] = ['must be valid.']
  end
end
