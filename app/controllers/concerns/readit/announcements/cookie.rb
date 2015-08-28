# Contains shared private methods for dealing with read announcement cookie.
#
# Author:: Denis Udovenko (mailto:denis.e.udovenko@gmail.com)
module Readit
  module Announcements
    module Cookie
      extend ActiveSupport::Concern

      private

      # Extracts hash with read announcements data from cookie.
      #
      # *Returns*
      # {Hash} Read announcements data hash
      def extract_read_announcements
        JSON.parse(cookies[:readit_announcements])
        rescue JSON::ParserError, TypeError
          {}
      end
    end
  end
end
