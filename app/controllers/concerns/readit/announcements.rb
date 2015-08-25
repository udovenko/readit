# Brings actual announcements collection into context.
#
# Author:: Denis Udovenko (mailto:denis.e.udovenko@gmail.com)
module Readit
  module Announcements
    extend ActiveSupport::Concern
    include Cookie

    included { before_action :set_announcements }

    private

    # Sets collection of active and actual announcements, not viewed by user.
    def set_announcements
      @announcements = Announcement.active.actual

      read_announcements = extract_read_announcements
      return if read_announcements.empty?

      @announcements = @announcements.exclude_read(read_announcements)
    end
  end
end
