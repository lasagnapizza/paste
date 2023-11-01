class Note < ApplicationRecord
  attr_accessor :new_password

  has_secure_password

  validates :body, presence: true
  validates :password, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug

  def self.random_password
    ("a".."z").to_a.sample(12).join.scan(/.{1,4}/).join("-")
  end

  def to_param
    slug
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
