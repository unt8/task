class User < ApplicationRecord
  validates :github_id, uniqueness: true
end
