class Image < ApplicationRecord
  validates :name, :url, presence: true
end
