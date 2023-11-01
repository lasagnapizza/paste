class Note < ApplicationRecord
  attr_accessor :new_password

  has_secure_password

  validates :body, presence: true
  validates :slug, uniqueness: true
  validates :password, length: (6..32), on: :create
  validates :password, length: (6..32), allow_blank: true, on: :update

  before_create :set_slug

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
