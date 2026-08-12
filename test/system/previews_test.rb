require "application_system_test_case"

class PreviewsTest < ApplicationSystemTestCase
  test "preview renders a table through the server" do
    visit root_path

    type_into_editor("| a | b |\n|---|---|\n| 1 | 2 |")
    click_on "preview"

    within(".markdown-body") do
      assert_selector "table thead th", text: "a"
      assert_selector "table tbody td", text: "1"
    end
  end

  test "preview matches the saved note" do
    body = "\"smart\" quotes -- dash\n\nline1\nline2"

    visit root_path
    type_into_editor(body)
    click_on "preview"
    assert_selector ".markdown-body p"
    previewed = find(".markdown-body")[:innerHTML]

    click_on "preview"
    click_on "paste"

    assert_selector ".markdown-body p"
    # the note page wraps the same html in erb whitespace
    assert_equal previewed.strip, find(".markdown-body")[:innerHTML].strip
  end

  test "toggling back returns to the editor" do
    visit root_path
    type_into_editor("hello")

    click_on "preview"
    assert_selector ".markdown-body", text: "hello"

    click_on "preview"
    assert_no_selector ".markdown-body p"
    assert_selector ".cm-editor"
  end

  # forgery protection is off in test, so turn it on to exercise the token the
  # preview fetch sends
  test "preview sends a usable csrf token" do
    with_forgery_protection do
      visit root_path
      type_into_editor("hello")
      click_on "preview"

      assert_selector ".markdown-body", text: "hello"
    end
  end

  test "preview reports a server failure" do
    with_forgery_protection do
      visit root_path
      type_into_editor("hello")

      execute_script("document.querySelector('meta[name=\"csrf-token\"]').content = 'nope'")
      click_on "preview"

      assert_selector ".markdown-body", text: "preview failed"
    end
  end

  private

  def with_forgery_protection
    was = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    yield
  ensure
    ActionController::Base.allow_forgery_protection = was
  end

  # codemirror owns the textarea, so we type into its contenteditable instead
  def type_into_editor(text)
    find(".cm-content").click.send_keys(text)
  end
end
