class Note < ApplicationRecord
  has_secure_password

  before_validation :set_slug

  private

  def set_slug
    return if slug.present?

    loop do
      self.slug = AdjectiveAdjectiveAnimal.call
      break unless Note.exists?(slug:)
    end
  end
end
