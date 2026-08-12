require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = Note.create!(body: "hello **world**", password: "123")
  end

  test "preview renders markdown" do
    post preview_path, params: {body: "hello **world**"}

    assert_response :success
    assert_equal "<p>hello <strong>world</strong></p>\n", response.body
  end

  test "preview renders tables" do
    post preview_path, params: {body: "| a | b |\n|---|---|\n| 1 | 2 |\n"}

    assert_response :success
    assert_select "table thead th", "a"
    assert_select "table tbody td", "1"
  end

  test "preview matches what the note page renders" do
    body = <<~MARKDOWN
      | a | b |
      |---|---|
      | 1 | 2 |

      "smart" quotes -- dash

      ```ruby
      puts :hi
      ```

      line1
      line2

      - [ ] task

      https://example.com
    MARKDOWN

    post preview_path, params: {body: body}
    assert_response :success
    preview = response.body

    @note.update!(body: body)
    get note_path(@note)
    assert_response :success

    assert_includes response.body, preview.strip
  end

  test "preview strips raw html" do
    post preview_path, params: {body: "<script>alert(1)</script>"}

    assert_response :success
    refute_includes response.body, "<script>"
  end

  test "preview truncates oversized bodies" do
    body = ("a" * NotesController::MAX_PREVIEW_BYTES) + "OVERFLOW"

    post preview_path, params: {body: body}

    assert_response :success
    refute_includes response.body, "OVERFLOW"
  end

  test "preview handles a missing body" do
    post preview_path

    assert_response :success
    assert_equal "", response.body
  end

  # /preview sits in front of `resources :notes, path: "/"`, so a GET falls
  # through to notes#show and looks for a note slugged "preview"
  test "get preview falls through to the note lookup" do
    get "/preview"
    assert_response :not_found
  end
end
