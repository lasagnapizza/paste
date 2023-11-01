class Note < ApplicationRecord
  has_secure_password

  validates :body, presence: true

  before_validation :set_slug

  def self.random_password
    ('a'..'z').to_a.shuffle[0,12].join.scan(/.{1,4}/).join('-')
  end

  private

  def set_slug
    return if slug.present?

    loop do
      self.slug = AdjectiveAdjectiveAnimal.call
      break unless Note.exists?(slug:)
    end
  end
end
