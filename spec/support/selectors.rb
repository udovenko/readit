module Selectors
  ANNOUNCEMENT_SELECTOR = '.alert.alert-info'
  ANNOUNCEMENT_READ_SUBMIT_BUTTON_SELECTOR = "#{ANNOUNCEMENT_SELECTOR} input[type='submit']"

  constants.each { |constant| const_get(constant).freeze }
end
