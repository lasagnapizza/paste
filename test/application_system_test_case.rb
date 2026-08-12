require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # chromium instead of chrome: that is what CI images and arch ship
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |options|
    options.binary = ENV["CHROME_BIN"] if ENV["CHROME_BIN"]
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
  end
end
