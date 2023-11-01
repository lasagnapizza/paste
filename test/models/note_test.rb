require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "should be valid" do
    note = Note.new(body: "This is a sample note", password: "123")
    assert note.valid?
  end

  test "body presence validation" do
    note = Note.new(slug: "sample-slug")
    refute note.valid?
    assert_includes note.errors[:body], "can't be blank"
  end

  test "generate slug if not present" do
    note = Note.new(body: "This is a sample note", slug: "")
    note.validate
    assert note.slug.present?
  end

  test "password presence validation" do
    note = Note.new(password: "")
    refute note.valid?
    assert_includes note.errors[:password], "can't be blank"
  end

  test "random_password" do
    random_password = Note.random_password
    assert_match(/\A[a-z]{4}-[a-z]{4}-[a-z]{4}\z/, random_password)
  end

  test "to_param should return slug" do
    note = Note.new(body: "This is a sample note", slug: "sample-slug")
    assert_equal "sample-slug", note.to_param
  end

  test "slug uniqueness" do
    Note.create(body: "Existing note", slug: "unique-slug", password: "123")
    new_note = Note.new(body: "New note", slug: "unique-slug")

    refute new_note.valid?

    assert_includes new_note.errors[:slug], "has already been taken"
  end
end
